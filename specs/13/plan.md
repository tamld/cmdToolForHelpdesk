# Task #13: Enforce CARE Spec Lint in CI

## Context (Why)

**Problem:** Spec files under `specs/` may be incomplete or missing required CARE sections (Context, Actions, Risks, Expectations), leading to unclear handoffs and implementation gaps.

**Goal:** Add a CI workflow that validates all `specs/**/*.md` files against the CARE spec structure and fails the build if required sections are missing or improperly formatted.

**Benefit:**

- Enforces documentation discipline at commit time
- Reduces back-and-forth during handoffs
- Aligns with LL-014 (handoff completeness) and LL-018 (reflection)

## Actions (What to do)

1. **Define CARE spec schema**
   - Required sections: `# Context`, `# Actions`, `# Risks`, `# Expectations`
   - Optional sections: `# Reflection`, `# Reverse Questions`
   - Metadata: task ID, author, status

2. **Implement lint script**
   - Language: Bash or Python (prefer Bash for simplicity)
   - Logic:
     - Find all `specs/**/*.md` files
     - Parse each file for required headings
     - Report missing/malformed sections
     - Exit non-zero if any file fails validation

3. **Add CI workflow**
   - File: `.github/workflows/lint_care_spec.yml`
   - Trigger: `push`, `pull_request` on paths `specs/**`
   - Job: run lint script on `ubuntu-latest`
   - Fail if lint script exits non-zero

4. **Test with sample specs**
   - Create valid and invalid spec files for testing
   - Verify CI catches invalid specs
   - Confirm valid specs pass

5. **Document usage**
   - Update `.agents/README.md` with CARE lint guidance
   - Add error messages that guide authors to fix issues

## Risks (What could go wrong)

- **Risk 1: Overly strict validation blocks legitimate edge cases**
  - Mitigation: Allow optional sections; only enforce core CARE headings
  - Escape hatch: Add `<!-- care-lint: skip -->` comment for special cases

- **Risk 2: Existing specs may fail new validation**
  - Mitigation: Run lint locally first; fix or exempt existing specs before enabling CI
  - Rollback: Disable workflow via PR if too many false positives

- **Risk 3: Script parsing fragile with Markdown variations**
  - Mitigation: Use regex for heading detection; test with varied formatting
  - Alternative: Consider markdown AST parser if Bash regex insufficient

## Expectations (Success criteria)

- [ ] CI workflow exists and runs on `specs/**` changes
- [ ] Lint script detects missing CARE sections and reports clear error messages
- [ ] At least 2 test specs (valid + invalid) demonstrate linter behavior
- [ ] Documentation updated in `.agents/README.md`
- [ ] CI passes on this PR before marking ready-for-handoff

## Reflection

- **Self-assessment:** This task is low-risk additive work (new workflow + script); no changes to production code.
- **Assumptions:**
  - CARE spec structure is agreed upon (Context, Actions, Risks, Expectations)
  - Markdown heading format is consistent (`# Section`)
- **Coverage gaps:**
  - No validation of section *content* (only presence of headings)
  - No enforcement of metadata fields yet

## Reverse Questions

- What happens if a spec legitimately doesn't fit CARE structure (e.g., a quick note or template)? Should we have a file naming convention to exclude certain files?
- If we add reflection and reverse_questions sections to CARE later, how do we handle backward compatibility with old specs?
- Should the linter also check for broken links or orphaned files in `specs/`?

---

**Spec Status:** Draft (authored)  
**Author:** GitHub Copilot (agemini mode)  
**Created:** 2025-10-23  
**Branch:** `feature/ci-care-lint-13-agemini`  
**PR:** #2
