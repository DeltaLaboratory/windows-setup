Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/utils.ps1" | Invoke-Expression

$progressIdScoop = 9
$scoopTotalSteps = 12 # Adjusted based on logical grouping of installations
$scoopCurrentStep = 0

$scoopCurrentStep++; $statusMessage = "Installing Scoop, Updating, and Configuring SQLite..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
I "Installing Scoop..."
Invoke-Expression "& {$(Invoke-RestMethod https://get.scoop.sh)} -RunAsAdmin"
if ($LASTEXITCODE -ne 0) {
    E "Error installing Scoop. Exit code: $LASTEXITCODE"
    throw "Scoop installation failed. Exit code: $LASTEXITCODE"
} else {
    I "Scoop Installed Successfully!"
}

I "Updating Scoop..."
scoop update *
if ($LASTEXITCODE -ne 0) {
    E "Error updating Scoop. Exit code: $LASTEXITCODE"
    throw "Scoop update failed. Exit code: $LASTEXITCODE"
} else {
    I "Scoop Updated Successfully!"
}

I "Configuring Scoop to use SQLite DB..."
scoop config use_sqlite_cache true
if ($LASTEXITCODE -ne 0) {
    E "Error configuring Scoop to use SQLite DB. Exit code: $LASTEXITCODE"
    throw "Scoop SQLite configuration failed. Exit code: $LASTEXITCODE"
} else {
    I "Scoop Configured to use SQLite DB Successfully!"
}

$scoopCurrentStep++; $statusMessage = "Installing Git & Git-LFS via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
I "Installing Git via Scoop..."
scoop install git
if ($LASTEXITCODE -ne 0) {
    E "Error installing Git. Exit code: $LASTEXITCODE"
    throw "Git installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "Git Installed Successfully!"
}

# Git additional setup
I "Setting up Git..."

# Install Git-LFS via Scoop
I "Installing Git-LFS via Scoop..."
scoop install git-lfs
if ($LASTEXITCODE -ne 0) {
    E "Error installing Git-LFS. Exit code: $LASTEXITCODE"
    throw "Git-LFS installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "Git-LFS Installed Successfully!"
}

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

$scoopCurrentStep++; $statusMessage = "Setting up Scoop Buckets (Extras, Nerd-Fonts)..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
# Setup scoop extras bucket
I "Setting up Scoop Extras Bucket..."
scoop bucket add extras
if ($LASTEXITCODE -ne 0) {
    E "Error setting up Scoop Extras Bucket. Exit code: $LASTEXITCODE"
    throw "Scoop Extras Bucket setup failed. Exit code: $LASTEXITCODE"
} else {
    I "Scoop Extras Bucket Setup Completed Successfully!"
}

# Setup scoop nerd font bucket
I "Setting up Scoop Nerd Font Bucket..."
scoop bucket add nerd-fonts
if ($LASTEXITCODE -ne 0) {
    E "Error setting up Scoop Nerd Font Bucket. Exit code: $LASTEXITCODE"
    throw "Scoop Nerd Font Bucket setup failed. Exit code: $LASTEXITCODE"
} else {
    I "Scoop Nerd Font Bucket Setup Completed Successfully!"
}

$scoopCurrentStep++; $statusMessage = "Installing Fonts (IBM Plex) via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
# Install fonts
I "Install IBM Flex Mono & KR..."
scoop install IBMPlexMono
if ($LASTEXITCODE -ne 0) {
    E "Error installing IBMPlexMono. Exit code: $LASTEXITCODE"
    throw "IBMPlexMono installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "IBMPlexMono Installed Successfully!"
}
scoop install IBMPlexSans-KR
if ($LASTEXITCODE -ne 0) {
    E "Error installing IBMPlexSans-KR. Exit code: $LASTEXITCODE"
    throw "IBMPlexSans-KR installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "IBMPlexSans-KR Installed Successfully!"
}

$scoopCurrentStep++; $statusMessage = "Installing Go via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
# Install Go via Scoop
I "Installing Go via Scoop..."
scoop install go
if ($LASTEXITCODE -ne 0) {
    E "Error installing Go. Exit code: $LASTEXITCODE"
    throw "Go installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "Go Installed Successfully!"
}

$scoopCurrentStep++; $statusMessage = "Installing Node.js & Setting up Corepack/pnpm via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
# Install Node.js via Scoop
I "Installing Node.js via Scoop..."
scoop install nodejs
if ($LASTEXITCODE -ne 0) {
    E "Error installing Node.js. Exit code: $LASTEXITCODE"
    throw "Node.js installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "Node.js Installed Successfully!"
}

# NodeJS additional setup
I "Setting up NodeJS..."
I "Enabling Corepack..."
corepack enable
if ($LASTEXITCODE -ne 0) {
    E "Error enabling Corepack. Exit code: $LASTEXITCODE"
    throw "Corepack enable failed. Exit code: $LASTEXITCODE"
} else {
    I "Corepack Enabled Successfully!"
}
corepack install pnpm@latest -g
if ($LASTEXITCODE -ne 0) {
    E "Error installing pnpm. Exit code: $LASTEXITCODE"
    throw "pnpm installation via Corepack failed. Exit code: $LASTEXITCODE"
} else {
    I "pnpm Installed Successfully!"
}
I "NodeJS Setup Completed Successfully!"

$scoopCurrentStep++; $statusMessage = "Installing Python & Setting up Poetry via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
# Install Python via Scoop
I "Installing Python via Scoop..."
scoop install python
if ($LASTEXITCODE -ne 0) {
    E "Error installing Python. Exit code: $LASTEXITCODE"
    throw "Python installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "Python Installed Successfully!"
}

# Python additional setup
I "Setting up Python..."
I "Installing Poetry..."
scoop install poetry
if ($LASTEXITCODE -ne 0) {
    E "Error installing Poetry. Exit code: $LASTEXITCODE"
    throw "Poetry installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "Poetry Installed Successfully!"
}
I "Python Setup Completed Successfully!"

$scoopCurrentStep++; $statusMessage = "Installing Gpg via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
# Install Gpg4win via Scoop
I "Installing gpg via Scoop..."
scoop install gpg
if ($LASTEXITCODE -ne 0) {
    E "Error installing gpg. Exit code: $LASTEXITCODE"
    throw "gpg installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "gpg Installed Successfully!"
}

$scoopCurrentStep++; $statusMessage = "Installing Github CLI via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
# Install Github CLI via Scoop
I "Installing Github CLI via Scoop..."
scoop install gh
if ($LASTEXITCODE -ne 0) {
    E "Error installing Github CLI. Exit code: $LASTEXITCODE"
    throw "Github CLI installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "Github CLI Installed Successfully!"
}

$scoopCurrentStep++; $statusMessage = "Installing MSYS2 & Setting up via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
# Install MSYS2 via Scoop
I "Installing MSYS2 via Scoop..."
scoop install msys2
if ($LASTEXITCODE -ne 0) {
    E "Error installing MSYS2. Exit code: $LASTEXITCODE"
    throw "MSYS2 installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "MSYS2 Installed Successfully!"
}

# MSYS2 additional setup
I "Setting up MSYS2..."
&"C:\\Users\\$env:USERNAME\\scoop\\apps\\msys2\\current\\msys2_shell.cmd" -defterm -no-start -here -mingw64 -full-path -c "pacman -Syuu --noconfirm"
if ($LASTEXITCODE -ne 0) {
    E "Error during MSYS2 setup (pacman -Syuu). Exit code: $LASTEXITCODE"
    throw "MSYS2 setup (pacman -Syuu) failed. Exit code: $LASTEXITCODE"
}
&"C:\\Users\\$env:USERNAME\\scoop\\apps\\msys2\\current\\msys2_shell.cmd" -defterm -no-start -here -mingw64 -full-path -c "pacman -Syuu --noconfirm"
if ($LASTEXITCODE -ne 0) {
    E "Error during MSYS2 setup (pacman -Syuu, second run). Exit code: $LASTEXITCODE"
    throw "MSYS2 setup (pacman -Syuu, second run) failed. Exit code: $LASTEXITCODE"
}
&"C:\\Users\\$env:USERNAME\\scoop\\apps\\msys2\\current\\msys2_shell.cmd" -defterm -no-start -here -ucrt64 -full-path -c "pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-toolchain"
if ($LASTEXITCODE -ne 0) {
    E "Error during MSYS2 setup (pacman -S toolchain). Exit code: $LASTEXITCODE"
    throw "MSYS2 setup (pacman -S toolchain) failed. Exit code: $LASTEXITCODE"
}

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

$scoopCurrentStep++; $statusMessage = "Installing Notepad++ via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
# Install Notepad++ via Scoop
I "Installing Notepad++ via Scoop..."
scoop install notepadplusplus
if ($LASTEXITCODE -ne 0) {
    E "Error installing Notepad++. Exit code: $LASTEXITCODE"
    throw "Notepad++ installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "Notepad++ Installed Successfully!"
}

$scoopCurrentStep++; $statusMessage = "Installing SMPlayer via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete (($scoopCurrentStep / $scoopTotalSteps) * 100) -Id $progressIdScoop
# Install SMPlayer via Scoop
I "Installing SMPlayer via Scoop..."
scoop install extras/smplayer
if ($LASTEXITCODE -ne 0) {
    E "Error installing SMPlayer. Exit code: $LASTEXITCODE"
    throw "SMPlayer installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    I "SMPlayer Installed Successfully!"
}

Write-Progress -Activity "Scoop Package Management" -Completed -Id $progressIdScoop
