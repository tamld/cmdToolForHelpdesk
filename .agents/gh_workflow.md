# Guide to working with cmdToolForHelpdesk repo using gh CLI

This document provides detailed instructions on how to use the `gh` CLI to interact with and manage the `cmdToolForHelpdesk` project.

## 1. Introduction

`gh` is GitHub's official command-line tool, allowing you to work with GitHub directly from your terminal. Using `gh` helps automate processes and increase work efficiency.

## 2. Installation and Authentication

First, ensure you have `gh` installed and authenticated with your GitHub account.

- **Check version:**
  ```bash
  gh --version
  ```
- **Check authentication status:**
  ```bash
  gh auth status
  ```

## 3. Working with the Repository

- **Clone repository:**
  ```bash
  gh repo clone tamld/cmdToolForHelpdesk
  ```

- **View repo information:**
  ```bash
  gh repo view tamld/cmdToolForHelpdesk
  ```

## 4. Managing Issues

- **Create a new issue:**
  ```bash
  gh issue create --title "Issue Title" --body "Detailed description of the issue"
  ```

- **List issues:**
  ```bash
  gh issue list
  ```

- **View issue details:**
  ```bash
  gh issue view <issue_number>
  ```

## 5. Managing Pull Requests (PRs)

- **Create a Pull Request:**
  ```bash
  gh pr create --title "PR Title" --body "Detailed description of the PR"
  ```

- **List PRs:**
  ```bash
  gh pr list
  ```

- **Checkout a PR locally:**
  ```bash
  gh pr checkout <pr_number>
  ```

- **Merge a PR:**
  ```bash
  gh pr merge <pr_number>
  ```

## 6. Backlog and Development Plan

This `.agents/` directory will store important project information:

- **`gh_workflow.md`**: Guide to working with `gh` CLI (this file).
- **`backlog.yml`**: List of features and tasks to be implemented.
- **`logs/`**: Directory containing agent activity logs and automated processes.
- **`rules.yml`**: Rules and conventions for contributing to the project.
- **`roadmap.yml`**: Overall project development roadmap.

I will continue to update and supplement these documents as the project evolves.