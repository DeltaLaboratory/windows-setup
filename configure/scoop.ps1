Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/modules/utils.ps1" | Invoke-Expression

I "Installing Scoop..."
Invoke-Expression "& {$(Invoke-RestMethod https://get.scoop.sh)} -RunAsAdmin"
I "Scoop Installed Successfully!"

I "Updating Scoop..."
scoop update *
I "Scoop Updated Successfully!"

I "Configuring Scoop to use SQLite DB..."
scoop config use_sqlite_cache true
I "Scoop Configured to use SQLite DB Successfully!"

I "Installing Git via Scoop..."
scoop install git
I "Git Installed Successfully!"

# Git additional setup
I "Setting up Git..."

# Install Git-LFS via Scoop
I "Installing Git-LFS via Scoop..."
scoop install git-lfs
I "Git-LFS Installed Successfully!"

Write-Output @"
[commit]
    gpgsign = true
[tag]
    gpgsign = true
[gpg]
    program = C:/Users/$env:USERNAME/scoop/apps/gpg/current/bin/gpg.exe
[filter "lfs"]
    smudge = git-lfs smudge -- %f
    process = git-lfs filter-process
    required = true
    clean = git-lfs clean -- %f
[init]
	defaultBranch = main
[core]
	autocrlf = false
	eol = lf
	symlinks = true
"@ | Out-File -FilePath $env:USERPROFILE\.gitconfig -Encoding utf8
I "Git Setup Completed Successfully!"

# Setup scoop extras bucket
I "Setting up Scoop Extras Bucket..."
scoop bucket add extras
I "Scoop Extras Bucket Setup Completed Successfully!"

# Setup scoop nerd font bucket
I "Setting up Scoop Nerd Font Bucket..."
scoop bucket add nerd-fonts
I "Scoop Nerd Font Bucket Setup Completed Successfully!"

# Install fonts
I "Install IBM Flex Mono & KR..."
scoop install IBMPlexMono
scoop install IBMPlexSans-KR
I "IBM Flex Mono & KR Installed Successfully!"

# Install Go via Scoop
I "Installing Go via Scoop..."
scoop install go
I "Go Installed Successfully!"

# Install Node.js via Scoop
I "Installing Node.js via Scoop..."
scoop install nodejs
I "Node.js Installed Successfully!"

# NodeJS additional setup
I "Setting up NodeJS..."
I "Enabling Corepack..."
corepack enable
corepack install pnpm@latest -g
I "Corepack Enabled Successfully!"
I "NodeJS Setup Completed Successfully!"

# Install Python via Scoop
I "Installing Python via Scoop..."
scoop install python
I "Python Installed Successfully!"

# Python additional setup
I "Setting up Python..."
I "Installing Poetry..."
scoop install poetry
I "Poetry Installed Successfully!"
I "Python Setup Completed Successfully!"

# Install Gpg4win via Scoop
I "Installing gpg via Scoop..."
scoop install gpg
I "gpg Installed Successfully!"

# Install Github CLI via Scoop
I "Installing Github CLI via Scoop..."
scoop install gh
I "Github CLI Installed Successfully!"

# Install MSYS2 via Scoop
I "Installing MSYS2 via Scoop..."
scoop install msys2
I "MSYS2 Installed Successfully!"

# MSYS2 additional setup
I "Setting up MSYS2..."
&"C:\Users\$env:USERNAME\scoop\apps\msys2\current\msys2_shell.cmd" -defterm -no-start -here -mingw64 -full-path -c "pacman -Syuu --noconfirm"
&"C:\Users\$env:USERNAME\scoop\apps\msys2\current\msys2_shell.cmd" -defterm -no-start -here -mingw64 -full-path -c "pacman -Syuu --noconfirm"
&"C:\Users\$env:USERNAME\scoop\apps\msys2\current\msys2_shell.cmd" -defterm -no-start -here -ucrt64 -full-path -c "pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-toolchain"

# Create MSYS2 Setup Batch File at Document Directory
I "Creating MSYS2 Update Batch File at Document Directory..."
$msys2SetupBatchFile = @"
@echo off
C:\Users\$env:USERNAME\scoop\apps\msys2\current\msys2_shell.cmd -defterm -no-start -here -ucrt64 -full-path -c "pacman -Syuu --noconfirm"
C:\Users\$env:USERNAME\scoop\apps\msys2\current\msys2_shell.cmd -defterm -no-start -here -ucrt64 -full-path -c "pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-toolchain"
"@
$msys2SetupBatchFilePath = Join-Path -Path $env:USERPROFILE\Documents -ChildPath "MSYS2_Update.bat"
$msys2SetupBatchFile | Out-File -FilePath $msys2SetupBatchFilePath -Encoding utf8

I "MSYS2 Setup Completed Successfully!"

# Install Notepad++ via Scoop
I "Installing Notepad++ via Scoop..."
scoop install notepadplusplus
I "Notepad++ Installed Successfully!"

# Install SMPlayer via Scoop
I "Installing SMPlayer via Scoop..."
scoop install extras/smplayer
I "SMPlayer Installed Successfully!"
