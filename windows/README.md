# System Configuration & Environment Setup

This repository contains system configuration files (dotfiles) managed via Chezmoi and administrative scripts for Windows 11 optimization.

## 🚀 Chezmoi Dotfiles Management

We use [Chezmoi](https://chezmoi.io) to manage local configuration states. The commands below target the current working directory as the source path.

### 1. Add Configuration File
Track the WezTerm configuration file by adding it to Chezmoi as a symlink:
```cmd
chezmoi add C:\Users\dev\.wezterm.lua -S .
```

### 2. Apply Changes
Forcefully apply the configuration changes to the system with verbose logging:
```cmd
chezmoi apply -v -S . --force
```
or do this
```cmd
.\update.bat
```
---

## ⚙️ Windows 11 Registry Tweaks

Administrative scripts to control workstation locking behavior. 

> [!WARNING]
> **Administrative Privileges Required:** The following commands must be executed in a Command Prompt running as **Administrator**.

### Disable Workstation Locking
Prevents the system from being locked (disables `Win + L` and lock options in the Start Menu):
```cmd
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DisableLockWorkstation /t REG_DWORD /d 1 /f
```

### Enable Workstation Locking (Default)
Restores the default Windows behavior, allowing users to lock the workstation normally:
```cmd
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DisableLockWorkstation /f
```

---

## 🛠️ Requirements
* Windows 11
* Chezmoi CLI installed
* Administrator privileges for Registry modifications
