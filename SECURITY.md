## 1. Overview

This repository contains shell scripts for automating development environment setup and maintenance on WSL (Ubuntu).  
Since these scripts perform privileged operations such as system package updates, file deletions, and Git branch management, users should review and understand each script before execution.

## 2. Supported Versions

| Version | Supported |
|---------|-----------|
| Latest  | Yes       |

## 3. Reporting a Vulnerability

If you discover a security vulnerability in this repository, please report it responsibly by contacting **@hayat01sh1da** directly rather than opening a public issue.

You can expect:

- An acknowledgement within a few days
- A fix or mitigation to be applied promptly

## 4. Security Considerations

### 4-1. Privileged Operations

`setup.sh` runs `sudo apt update`, `sudo apt full-upgrade`, and `sudo apt auto-remove`, which require elevated privileges.  
Only run this script in a trusted environment.

### 4-2. Destructive File Operations

- `flush.sh` permanently removes directories and files (e.g. `.cache/`, `.bash_history`, `.local/`) using `rm -rf`.  
Ensure you understand which targets will be deleted before running.
- `flush.sh` also bulk-uninstalls all user-installed Ruby gems and Python libraries.

### 4-3. Git Branch Management

- `flush_and_update_oss_repos.sh` and `flush_and_update_personal_repos.sh` force-delete local and remote-tracking branches. Verify that no in-progress work exists on those branches before execution.
- `setup.sh` performs similar branch cleanup on language environment plugin repositories.

### 4-4. Symbolic Links

`symbolic_link.sh` creates symbolic links from WSL to Windows user directories. The Windows username is hardcoded in the script — update it to match your own environment before use.

### 4-5. Dependency Management

`Gemfile` and pip dependencies are managed via `setup.sh`.  
Always review dependency updates and lock files (`Gemfile.lock`, `requirements.lock`) to guard against supply chain attacks.

## 5. Best Practices

1. **Review before running** — Read each script thoroughly before execution, especially on a new machine.
2. **Back up important data** — `flush.sh` and branch-cleanup scripts are irreversible.
3. **Keep dependencies up to date** — Run `setup.sh` regularly to apply security patches for system packages, gems, and Python libraries.
4. **Do not commit secrets** — Avoid storing credentials, tokens, or private keys in this repository or any scripts derived from it.
