I "Starting Winget Configuration..."

I "Upgrading Windows Package Manager (Winget)..."
winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements
I "Windows Package Manager (Winget) Upgraded Successfully!"

# Install Bandizip via Winget
I "Installing Bandizip via Winget..."
winget install Bandisoft.Bandizip --accept-package-agreements --accept-source-agreements
I "Bandizip Installed Successfully!"

# Install Bandiview via Winget
I "Installing Bandiview via Winget..."
winget install Bandisoft.Bandiview --accept-package-agreements --accept-source-agreements
I "Bandiview Installed Successfully!"

# Install JetBrains Toolbox via Winget
I "Installing JetBrains Toolbox via Winget..."
winget install JetBrains.Toolbox --accept-package-agreements --accept-source-agreements
I "JetBrains Toolbox Installed Successfully!"

# Install Powershell 7 via Winget
I "Installing Powershell 7 via Winget..."
winget install Microsoft.PowerShell --accept-package-agreements --accept-source-agreements
I "Powershell 7 Installed Successfully!"

# Install Snipping Tool via Winget
I "Installing Snipping Tool via Winget..."
winget install 9MZ95KL8MR0L --accept-package-agreements --accept-source-agreements
I "Snipping Tool Installed Successfully!"

I "Installing PowerToys via Winget..."
winget install Microsoft.Powertoys --accept-package-agreements --accept-source-agreements
I "PowerToys Installed Successfully!"

I "Winget Configuration Completed Successfully!"