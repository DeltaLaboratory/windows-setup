# Load dependencies - this script should only be called from main.ps1 or other scripts that have already loaded config and utils

Write-BoxedHeader "🪣 SCOOP PACKAGE MANAGER" "DarkYellow" 70

$progressIdScoop = $Global:PROGRESS_IDS.Scoop
$scoopTotalSteps = 12
$scoopCurrentStep = 0

Write-StatusLine "🚀" "Installing development tools and applications..." "Yellow"
Write-StatusLine "📊" "Total Installation Groups: $scoopTotalSteps" "DarkGray"
Write-Host ""

$scoopCurrentStep++; $statusMessage = "Installing Scoop, Updating, and Configuring SQLite..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-SectionHeader "SCOOP INSTALLATION & SETUP" "🔧"
Write-StatusLine "📦" "Installing Scoop package manager..." "Cyan"
Invoke-Expression "& {$(Invoke-RestMethod https://get.scoop.sh)} -RunAsAdmin"
if ($LASTEXITCODE -ne 0) {
    E "Error installing Scoop. Exit code: $LASTEXITCODE"
    throw "Scoop installation failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Scoop installed successfully!"
}

Write-StatusLine "🔄" "Updating Scoop..." "Cyan"
scoop update *
if ($LASTEXITCODE -ne 0) {
    E "Error updating Scoop. Exit code: $LASTEXITCODE"
    throw "Scoop update failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Scoop updated successfully!"
}

Write-StatusLine "💾" "Configuring Scoop to use SQLite database..." "Cyan"
scoop config use_sqlite_cache true
if ($LASTEXITCODE -ne 0) {
    E "Error configuring Scoop to use SQLite DB. Exit code: $LASTEXITCODE"
    throw "Scoop SQLite configuration failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Scoop SQLite configuration completed!"
}

$scoopCurrentStep++; $statusMessage = "Installing Git & Git-LFS via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-SectionHeader "VERSION CONTROL TOOLS" "🌿"
Write-StatusLine "📚" "Installing Git version control system..." "Cyan"
scoop install git
if ($LASTEXITCODE -ne 0) {
    E "Error installing Git. Exit code: $LASTEXITCODE"
    throw "Git installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Git installed successfully!"
}

Write-StatusLine "📁" "Installing Git-LFS for large file support..." "Cyan"
scoop install git-lfs
if ($LASTEXITCODE -ne 0) {
    E "Error installing Git-LFS. Exit code: $LASTEXITCODE"
    throw "Git-LFS installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Git-LFS installed successfully!"
}

Write-StatusLine "⚙️" "Configuring Git settings..." "Cyan"
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
Write-Success "Git configuration completed!"

$scoopCurrentStep++; $statusMessage = "Setting up Scoop Buckets (Extras, Nerd-Fonts)..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-SectionHeader "SCOOP BUCKETS SETUP" "📦"
Write-StatusLine "🎯" "Adding extras bucket for additional applications..." "Cyan"
scoop bucket add extras
if ($LASTEXITCODE -ne 0) {
    E "Error setting up Scoop Extras Bucket. Exit code: $LASTEXITCODE"
    throw "Scoop Extras Bucket setup failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Scoop extras bucket added!"
}

Write-StatusLine "🔤" "Adding nerd-fonts bucket for developer fonts..." "Cyan"
scoop bucket add nerd-fonts
if ($LASTEXITCODE -ne 0) {
    E "Error setting up Scoop Nerd Font Bucket. Exit code: $LASTEXITCODE"
    throw "Scoop Nerd Font Bucket setup failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Scoop nerd-fonts bucket added!"
}

$scoopCurrentStep++; $statusMessage = "Installing Fonts (IBM Plex) via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-SectionHeader "DEVELOPER FONTS" "🔤"
Write-StatusLine "📝" "Installing IBM Plex Mono font..." "Cyan"
scoop install IBMPlexMono
if ($LASTEXITCODE -ne 0) {
    E "Error installing IBMPlexMono. Exit code: $LASTEXITCODE"
    throw "IBMPlexMono installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "IBM Plex Mono installed!"
}

Write-StatusLine "🇰🇷" "Installing IBM Plex Sans Korean font..." "Cyan"
scoop install IBMPlexSans-KR
if ($LASTEXITCODE -ne 0) {
    E "Error installing IBMPlexSans-KR. Exit code: $LASTEXITCODE"
    throw "IBMPlexSans-KR installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "IBM Plex Sans KR installed!"
}

$scoopCurrentStep++; $statusMessage = "Installing Go via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-SectionHeader "PROGRAMMING LANGUAGES" "👨‍💻"
Write-StatusLine "🐹" "Installing Go programming language..." "Cyan"
scoop install go
if ($LASTEXITCODE -ne 0) {
    E "Error installing Go. Exit code: $LASTEXITCODE"
    throw "Go installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Go programming language installed!"
}

$scoopCurrentStep++; $statusMessage = "Installing Node.js & Setting up Corepack/pnpm via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-StatusLine "🟢" "Installing Node.js runtime..." "Cyan"
scoop install nodejs
if ($LASTEXITCODE -ne 0) {
    E "Error installing Node.js. Exit code: $LASTEXITCODE"
    throw "Node.js installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Node.js installed!"
}

Write-StatusLine "📦" "Configuring Node.js package managers..." "Cyan"
Write-StatusLine "  🔧" "Enabling Corepack..." "DarkCyan"
corepack enable
if ($LASTEXITCODE -ne 0) {
    E "Error enabling Corepack. Exit code: $LASTEXITCODE"
    throw "Corepack enable failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "  Corepack enabled!"
}

Write-StatusLine "  📚" "Installing pnpm package manager..." "DarkCyan"
corepack install pnpm@latest -g
if ($LASTEXITCODE -ne 0) {
    E "Error installing pnpm. Exit code: $LASTEXITCODE"
    throw "pnpm installation via Corepack failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "  pnpm installed!"
}

$scoopCurrentStep++; $statusMessage = "Installing Python & Setting up Poetry via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-StatusLine "🐍" "Installing Python programming language..." "Cyan"
scoop install python
if ($LASTEXITCODE -ne 0) {
    E "Error installing Python. Exit code: $LASTEXITCODE"
    throw "Python installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Python installed!"
}

Write-StatusLine "📝" "Installing Poetry dependency manager..." "Cyan"
scoop install poetry
if ($LASTEXITCODE -ne 0) {
    E "Error installing Poetry. Exit code: $LASTEXITCODE"
    throw "Poetry installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Poetry installed!"
}

$scoopCurrentStep++; $statusMessage = "Installing GPG via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-SectionHeader "SECURITY TOOLS" "🔐"
Write-StatusLine "🔒" "Installing GPG for cryptographic operations..." "Cyan"
scoop install gpg
if ($LASTEXITCODE -ne 0) {
    E "Error installing gpg. Exit code: $LASTEXITCODE"
    throw "gpg installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "GPG installed!"
}

$scoopCurrentStep++; $statusMessage = "Installing Github CLI via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-StatusLine "🐙" "Installing GitHub CLI..." "Cyan"
scoop install gh
if ($LASTEXITCODE -ne 0) {
    E "Error installing Github CLI. Exit code: $LASTEXITCODE"
    throw "Github CLI installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "GitHub CLI installed!"
}

$scoopCurrentStep++; $statusMessage = "Installing MSYS2 & Setting up via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-SectionHeader "DEVELOPMENT ENVIRONMENT" "🔨"
Write-StatusLine "🛠️" "Installing MSYS2 Unix-like environment..." "Cyan"
scoop install msys2
if ($LASTEXITCODE -ne 0) {
    E "Error installing MSYS2. Exit code: $LASTEXITCODE"
    throw "MSYS2 installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "MSYS2 installed!"
}

Write-StatusLine "⚙️" "Configuring MSYS2 environment..." "Cyan"
Write-StatusLine "  🔄" "Running initial system update..." "DarkCyan"
&"C:\\Users\\$env:USERNAME\\scoop\\apps\\msys2\\current\\msys2_shell.cmd" -defterm -no-start -here -mingw64 -full-path -c "pacman -Syuu --noconfirm"
if ($LASTEXITCODE -ne 0) {
    E "Error during MSYS2 setup (pacman -Syuu). Exit code: $LASTEXITCODE"
    throw "MSYS2 setup (pacman -Syuu) failed. Exit code: $LASTEXITCODE"
}

Write-StatusLine "  🔄" "Running second system update..." "DarkCyan"
&"C:\\Users\\$env:USERNAME\\scoop\\apps\\msys2\\current\\msys2_shell.cmd" -defterm -no-start -here -mingw64 -full-path -c "pacman -Syuu --noconfirm"
if ($LASTEXITCODE -ne 0) {
    E "Error during MSYS2 setup (pacman -Syuu, second run). Exit code: $LASTEXITCODE"
    throw "MSYS2 setup (pacman -Syuu, second run) failed. Exit code: $LASTEXITCODE"
}

Write-StatusLine "  🧰" "Installing GCC toolchain..." "DarkCyan"
&"C:\\Users\\$env:USERNAME\\scoop\\apps\\msys2\\current\\msys2_shell.cmd" -defterm -no-start -here -ucrt64 -full-path -c "pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-toolchain"
if ($LASTEXITCODE -ne 0) {
    E "Error during MSYS2 setup (pacman -S toolchain). Exit code: $LASTEXITCODE"
    throw "MSYS2 setup (pacman -S toolchain) failed. Exit code: $LASTEXITCODE"
}

Write-StatusLine "  📝" "Creating MSYS2 update batch file..." "DarkCyan"
$msys2SetupBatchFile = @"
@echo off
C:\Users\$env:USERNAME\scoop\apps\msys2\current\msys2_shell.cmd -defterm -no-start -here -ucrt64 -full-path -c "pacman -Syuu --noconfirm"
C:\Users\$env:USERNAME\scoop\apps\msys2\current\msys2_shell.cmd -defterm -no-start -here -ucrt64 -full-path -c "pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-toolchain"
"@
$msys2SetupBatchFilePath = Join-Path -Path $env:USERPROFILE\Documents -ChildPath "MSYS2_Update.bat"
$msys2SetupBatchFile | Out-File -FilePath $msys2SetupBatchFilePath -Encoding utf8
Write-Success "MSYS2 setup completed!"

$scoopCurrentStep++; $statusMessage = "Installing Notepad++ via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-SectionHeader "PRODUCTIVITY APPLICATIONS" "📝"
Write-StatusLine "📄" "Installing Notepad++ text editor..." "Cyan"
scoop install notepadplusplus
if ($LASTEXITCODE -ne 0) {
    E "Error installing Notepad++. Exit code: $LASTEXITCODE"
    throw "Notepad++ installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Notepad++ installed!"
}

$scoopCurrentStep++; $statusMessage = "Installing SMPlayer via Scoop..."; Write-Progress -Activity "Scoop Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($scoopCurrentStep / $scoopTotalSteps) * 100))) -Id $progressIdScoop
Write-StatusLine "🎬" "Installing SMPlayer media player..." "Cyan"
scoop install extras/smplayer
if ($LASTEXITCODE -ne 0) {
    E "Error installing SMPlayer. Exit code: $LASTEXITCODE"
    throw "SMPlayer installation via Scoop failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "SMPlayer installed!"
}

Write-Progress -Activity "Scoop Package Management" -Completed -Id $progressIdScoop
Write-Host ""
Write-BoxedHeader "🎉 SCOOP INSTALLATION COMPLETE!" "Green" 60

Write-StatusLine "✨" "Development environment summary:" "Green"
Write-StatusLine "  🌿" "Git + Git-LFS for version control" "DarkGray"
Write-StatusLine "  🔤" "IBM Plex fonts for coding" "DarkGray"
Write-StatusLine "  🐹" "Go programming language" "DarkGray"
Write-StatusLine "  🟢" "Node.js + pnpm package manager" "DarkGray"
Write-StatusLine "  🐍" "Python + Poetry dependency manager" "DarkGray"
Write-StatusLine "  🔒" "GPG for cryptographic operations" "DarkGray"
Write-StatusLine "  🐙" "GitHub CLI for repository management" "DarkGray"
Write-StatusLine "  🛠️" "MSYS2 + GCC toolchain" "DarkGray"
Write-StatusLine "  📄" "Notepad++ and SMPlayer" "DarkGray"
