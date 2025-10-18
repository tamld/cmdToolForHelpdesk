# Core Principles

## 1. Don't Tell, Prove It

- **Principle:** All work, changes, and decisions must be backed by verifiable proof.
- **Implementation:**
    - **Backlog:** Maintain a clear and detailed backlog for all tasks.
    - **Proof of Work:** Link every completed task to its proof (e.g., test cases, metrics, logs, demos).

## 2. Rigorous Backlog Management

- **Principle:** The backlog is the source of truth for all work. It must be consulted before any new task is started.
- **Required Fields:**
    - `Task`: A clear description of the work.
    - `Status`: `New`, `In Progress`, or `Done`.
    - `Priority`: The urgency of the task (e.g., `High`, `Medium`, `Low`).
    - `Owner`: The person or agent responsible for the task.
    - `DueDate`: The target completion date.

## 3. Root Cause Analysis

- **Principle:** Never address only the symptoms. Always identify and fix the root cause of a problem.
- **Process:**
    - **Analysis:** Thoroughly investigate the issue.
    - **Evidence:** Gather concrete evidence to support the analysis.
    - **Fix:** Implement a complete and robust solution.

## 4. No Placeholders

- **Principle:** All implemented code must be complete and production-ready. Avoid empty or incomplete placeholders.
- **Requirements:**
    - **Full Implementation:** Features and fixes must be fully coded.
    - **Unit Tests:** All new code must be accompanied by corresponding unit tests to ensure correctness and prevent regressions.
