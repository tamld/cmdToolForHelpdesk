#!/usr/bin/env bash
# virtualboxctl.sh - VirtualBox VM Orchestrator
# Description: Manage VM lifecycle, unified snapshot commands, and folder sync

set -euo pipefail
IFS=$'\n\t'
trap 'echo "[ERROR] at line $LINENO" >&2; exit 1' ERR

# Defaults
VM_NAME=""
HEADLESS=false
DEBUG=false

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] <command> [args]

Options:
  -h, --help            Show this help
  -n, --name NAME       Specify VM name (auto if one exists)
  -l, --headless        Start VM headless (default GUI)
  --debug               Enable debug mode

Commands:
  start                 Start VM
  status                Show VM info summary
  halt                  Graceful shutdown (ACPI)
  poweroff              Force power off
  restart               Reset VM
  destroy               Delete VM

  snapshot [opts]       VM snapshot operations:
    -L, --list          List snapshots (indexed)
    -c, --create NAME   Create snapshot
    -m, --description DESC  Description for create
    -r, --restore IDX   Restore by index
    -d, --delete IDX    Delete by index
    --dry-run           Simulate snapshot action
    --yes               Skip confirmation for delete

  push [path]           Sync folder to VM ~/Desktop/public (default project root)
EOF
}

check_dependencies() {
  command -v VBoxManage >/dev/null || { echo "[ERROR] VBoxManage not found" >&2; exit 1; }
}

check_vm_exists() {
  mapfile -t VMS < <(VBoxManage list vms | awk -F'"' '{print $2}')
  case ${#VMS[@]} in
    0)
      echo "[ERROR] No VMs available" >&2
      exit 1
      ;;
    1)
      [ -z "$VM_NAME" ] && VM_NAME="${VMS[0]}" && echo "[INFO] Using VM: $VM_NAME"
      ;;
    *)
      if [ -z "$VM_NAME" ]; then
        echo "[ERROR] Multiple VMs found. Use --name. Available: ${VMS[*]}" >&2
        exit 1
      fi
      [[ ! " ${VMS[*]} " =~ " $VM_NAME " ]] && echo "[ERROR] VM '$VM_NAME' not found" >&2 && exit 1
      ;;
  esac
}

start_vm() {
  check_vm_exists
  echo "[INFO] Starting $VM_NAME${HEADLESS:+ headless}..."
  if $HEADLESS; then
    VBoxManage startvm "$VM_NAME" --type headless
  else
    VBoxManage startvm "$VM_NAME"
  fi
}

status_vm() {
  check_vm_exists
  VBoxManage showvminfo "$VM_NAME" --machinereadable | sed -n '1,20p'
}

halt_vm() {
  check_vm_exists
  echo "[INFO] Sending ACPI shutdown to $VM_NAME..."
  VBoxManage controlvm "$VM_NAME" acpipowerbutton
}

poweroff_vm() {
  check_vm_exists
  echo "[INFO] Forcing power off $VM_NAME..."
  VBoxManage controlvm "$VM_NAME" poweroff
}

restart_vm() {
  check_vm_exists
  echo "[INFO] Resetting $VM_NAME..."
  VBoxManage controlvm "$VM_NAME" reset
}

destroy_vm() {
  check_vm_exists
  echo "[INFO] Unregistering and deleting $VM_NAME..."
  VBoxManage unregistervm "$VM_NAME" --delete
}

snapshot_cmd() {
  check_vm_exists
  local opts action name desc="" idx=""
  local dry_run=false
  local confirm=false
  local -a snap_names=()
  local -a snap_descs=()
  local -a snap_uuids=()

  # Parse options manually to better handle optional arguments
  action=list
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -L|--list)
        action=list
        shift
        ;;
      -c|--create)
        action=create
        name="$2"
        shift 2
        ;;
      -m|--description)
        desc="$2"
        shift 2
        ;;
      -r|--restore)
        action=restore
        if [[ $# -gt 1 && ! "$2" =~ ^- ]]; then
          idx="$2"
          shift 2
        else
          shift
        fi
        ;;
      -d|--delete)
        action=delete
        if [[ $# -gt 1 && ! "$2" =~ ^- ]]; then
          idx="$2"
          shift 2
        else
          shift
        fi
        ;;
      --dry-run)
        dry_run=true
        shift
        ;;
      -y|--yes)
        confirm=true
        shift
        ;;
      *)
        # Unknown option or argument
        shift
        ;;
    esac
  done

  # Load existing snapshots
  local -a snapshots=()
  local -A names=()
  local -A uuids=()
  local -A descs=()
  local -a order=()
  
  mapfile -t snapshot_data < <(VBoxManage snapshot "$VM_NAME" list --machinereadable)
  
  # First process snapshot names and UUIDs
  for line in "${snapshot_data[@]}"; do
    if [[ "$line" =~ ^SnapshotName(-[0-9-]+)?=\"(.*)\"$ ]]; then
      local id="${BASH_REMATCH[1]:-root}"
      names[$id]="${BASH_REMATCH[2]}"
      # Track order of snapshots
      order+=("$id")
    elif [[ "$line" =~ ^SnapshotUUID(-[0-9-]+)?=\"(.*)\"$ ]]; then
      local id="${BASH_REMATCH[1]:-root}"
      uuids[$id]="${BASH_REMATCH[2]}"
    elif [[ "$line" =~ ^SnapshotDescription(-[0-9-]+)?=\"(.*)\"$ ]]; then
      local id="${BASH_REMATCH[1]:-root}"
      descs[$id]="${BASH_REMATCH[2]}"
    fi
  done
  
  # Build ordered list of complete snapshot entries
  for id in "${order[@]}"; do
    if [[ -n "${names[$id]:-}" && -n "${uuids[$id]:-}" ]]; then
      snapshots+=("${names[$id]}|${uuids[$id]}|${descs[$id]:-}")
    fi
  done
  
  case "$action" in
    list)
      echo "[INFO] VM '$VM_NAME' Snapshots:"
      for i in "${!snapshots[@]}"; do
        IFS='|' read -r name uuid desc <<< "${snapshots[$i]}"
        printf "%d) %s (UUID: %s) - %s\n" \
          "$i" \
          "$name" \
          "$uuid" \
          "${desc:-No description}"
      done
      ;;

    create)
      [ -z "$name" ] && { echo "[ERROR] --create requires NAME" >&2; exit 1; }
      echo "[INFO] Creating snapshot '$name'..."
      $dry_run && { echo "[DRY-RUN] Skipped snapshot creation"; return; }
      if [ -n "$desc" ]; then
        VBoxManage snapshot "$VM_NAME" take "$name" --description "$desc"
      else
        VBoxManage snapshot "$VM_NAME" take "$name"
      fi
      ;;

    restore)
      if [ -z "$idx" ]; then
        echo "[WARN] No index provided for restore. Listing snapshots instead..."
        ${FUNCNAME[0]} --list
        return
      fi
      if ! [[ "$idx" =~ ^[0-9]+$ ]] || [ "$idx" -ge ${#snapshots[@]} ]; then
        echo "[ERROR] Invalid index: $idx" >&2; exit 1
      fi
      
      # Get snapshot details
      IFS='|' read -r name uuid desc <<< "${snapshots[$idx]}"
      
      # Check VM state
      local vm_state
      local was_running=false
      vm_state=$(VBoxManage showvminfo "$VM_NAME" --machinereadable | grep '^VMState=' | cut -d'=' -f2 | tr -d '"')
      
      # Track if the VM was running before restore
      [ "$vm_state" == "running" ] && was_running=true
      
      # Power off VM if it's running
      if [ "$vm_state" == "running" ]; then
        echo "[INFO] Powering off $VM_NAME before snapshot restore..."
        $dry_run && { echo "[DRY-RUN] Would power off VM"; } || {
          VBoxManage controlvm "$VM_NAME" poweroff
          # Give the VM time to shut down
          sleep 2
        }
      fi
      
      echo "[INFO] Restoring snapshot '$name' (UUID: $uuid)..."
      $dry_run && { echo "[DRY-RUN] Skipped restore"; } || {
        VBoxManage snapshot "$VM_NAME" restore "$uuid"
        
        # Start VM again after restore (always start regardless of previous state)
        echo "[INFO] Starting VM after snapshot restore..."
        if $HEADLESS; then
          VBoxManage startvm "$VM_NAME" --type headless
        else
          VBoxManage startvm "$VM_NAME"
        fi
      }
      ;;

    delete)
      if [ -z "$idx" ]; then
        echo "[WARN] No index provided for delete. Listing snapshots instead..."
        ${FUNCNAME[0]} --list
        return
      fi
      if ! [[ "$idx" =~ ^[0-9]+$ ]] || [ "$idx" -ge ${#snapshots[@]} ]; then
        echo "[ERROR] Invalid index: $idx" >&2; exit 1
      fi
      
      # Get snapshot details
      IFS='|' read -r name uuid desc <<< "${snapshots[$idx]}"
      
      if ! $confirm; then
        read -rp "[CONFIRM] Delete snapshot '$name'? (y/N): " ans
        [[ ! "$ans" =~ ^[Yy]$ ]] && { echo "Aborted."; return; }
      fi
      echo "[INFO] Deleting snapshot '$name' (UUID: $uuid)..."
      $dry_run && { echo "[DRY-RUN] Skipped delete"; return; }
      VBoxManage snapshot "$VM_NAME" delete "$uuid"
      ;;

    *)
      echo "[ERROR] Unknown snapshot action: $action" >&2
      exit 1
      ;;
  esac
}

sync_folder() {
  check_vm_exists
  local src="${1:-$PROJECT_ROOT}"
  [ ! -e "$src" ] && { echo "[ERROR] '$src' not found" >&2; exit 1; }
  local state
  state=$(VBoxManage showvminfo "$VM_NAME" --machinereadable | grep '^VMState=' | cut -d'=' -f2 | tr -d '"')
  [ "$state" != "running" ] && { echo "[ERROR] VM not running" >&2; exit 1; }
  VBoxManage sharedfolder remove "$VM_NAME" --name public &>/dev/null || true
  echo "[INFO] Sharing public -> $src"
  VBoxManage sharedfolder add "$VM_NAME" --name public --hostpath "$src" --automount
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) usage; exit;;
      -n|--name) VM_NAME="$2"; shift 2;;
      -l|--headless) HEADLESS=true; shift;;
      --debug) DEBUG=true; shift;;
      start|status|halt|poweroff|restart|destroy|snapshot|push) break;;
      --) shift; break;;
      *) echo "[ERROR] Unknown option: $1" >&2; usage; exit 1;;
    esac
  done
  $DEBUG && set -x
  check_dependencies
  local cmd="${1:-}"
  shift || true
  case "$cmd" in
    start) start_vm;;
    status) status_vm;;
    halt) halt_vm;;
    poweroff) poweroff_vm;;
    restart) restart_vm;;
    destroy) destroy_vm;;
    snapshot) snapshot_cmd "$@";;
    push) sync_folder "$@";;
    *) echo "[ERROR] Unknown command '$cmd'" >&2; usage; exit 1;;
  esac
}

main "$@"
