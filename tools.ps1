# This script was copied from David Okeyode's Github. Checkout his excellent work. I take no credit for any of this. 
 
# Set PowerShell Execution Policy
Set-ExecutionPolicy Unrestricted -Force

# Install Chocolatey
$env:chocolateyVersion = '1.4.0'
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install CLI tools and SDKs using chocolatey
choco install azure-cli az.powershell terraform pulumi nodejs.install docker-desktop go rust -y
choco install miniconda3 --version=4.12.0 --params="'/AddToPath:1 /InstallationType:AllUsers /RegisterPython:1'" -y
choco install microsoft-windows-terminal --pre -y

# Create folder structure for pentest tools
$folders = @(
    "$env:SystemDrive\Tools",
    "$env:SystemDrive\Tools\Azure",
    "$env:SystemDrive\Tools\Azure\Attack",
    "$env:SystemDrive\Tools\Azure\Attack\BloodHound",
    "$env:SystemDrive\Tools\Azure\Attack\StormSpotter",
    "$env:SystemDrive\Tools\Azure\Assessment",
    "$env:SystemDrive\Tools\Azure\VulnerableEnv"
)
$folders | ForEach-Object { New-Item -ItemType Directory -Path $_ }

# Add the pentest tools folder to the Windows Defender exclusion list
Add-MpPreference -ExclusionPath "$env:SystemDrive\Tools"

# Install the Azure PowerShell modules
Install-Module -Name AzureAD -Force -AllowClobber
Install-Module -Name Az -Force -AllowClobber
Install-Module -Name AzureADPreview -Force -AllowClobber
Install-Module -Name Microsoft.Graph -Force -AllowClobber

# Install Azure AD Internals
Install-Module AADInternals -Force

# Add MicroBurst
git clone https://github.com/NetSPI/MicroBurst.git "$env:SystemDrive\Tools\Azure\Attack\MicroBurst"

# Add PowerZure
git clone https://github.com/hausec/PowerZure.git "$env:SystemDrive\Tools\Azure\Attack\PowerZure"

# Add AzureHound
Invoke-WebRequest -Uri "https://github.com/BloodHoundAD/AzureHound/releases/download/v2.0.4/azurehound-windows-amd64.zip" -OutFile "$env:SystemDrive\Downloads\AzureHound.zip"
Expand-Archive -LiteralPath "$env:SystemDrive\Downloads\AzureHound.zip" -DestinationPath "$env:SystemDrive\Tools\Azure\Attack\AzureHound"
Remove-Item "$env:SystemDrive\Downloads\AzureHound.zip"

# Add FuncoPop
git clone https://github.com/NetSPI/FuncoPop.git "$env:SystemDrive\Tools\Azure\Attack\FuncoPop"

# Add BARK
git clone https://github.com/BloodHoundAD/BARK "$env:SystemDrive\Tools\Azure\Attack\BARK"

# Add CloudFox
git clone https://github.com/BishopFox/cloudfox.git "$env:SystemDrive\Tools\Azure\Attack\cloudfox"

# Add SkyArk
git clone https://github.com/cyberark/SkyArk "$env:SystemDrive\Tools\Azure\Attack\SkyArk"

# Add MSOLSpray
git clone https://github.com/dafthack/MSOLSpray "$env:SystemDrive\Tools\Azure\Attack\MSOLSpray"

# Add Azure-AccessPermissions
git clone https://github.com/csandker/Azure-AccessPermissions.git "$env:SystemDrive\Tools\Azure\Assessment\Azure-AccessPermissions"

# Add ScubaGear 
Invoke-WebRequest -Uri "https://github.com/cisagov/ScubaGear/releases/download/0.3.0/ScubaGear-0.3.0.zip" -OutFile "$env:SystemDrive\Downloads\ScubaGear.zip"
Expand-Archive -Path "$env:SystemDrive\Downloads\ScubaGear.zip" -DestinationPath "$env:SystemDrive\Tools\Azure\Assessment" -Force
Get-ChildItem -Recurse "$env:SystemDrive\Tools\Azure\Assessment\ScubaGear-0.3.0" | Unblock-File
Remove-Item -Path "$env:SystemDrive\Downloads\ScubaGear.zip"

# Add Stormspotter
git clone https://github.com/Azure/Stormspotter/ "$env:SystemDrive\Tools\Azure\Attack\StormSpotter"

# Add ScoutSuite
git clone https://github.com/nccgroup/ScoutSuite "$env:SystemDrive\Tools\Azure\Assessment\ScoutSuite"


# Disable IE First Run (Needed by some tools)
if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer" -Name "Main" -Force
}

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\Main" -Name "RunOnceComplete" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\Main" -Name "RunOnceHasShown" -Value 1 -Type DWord -Force

# Install Python
choco install python --version=3.7.2 -y
$pythonlocation = "$env:SystemDrive\Python37"

# Install Pip
Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "get-pip.py"
. $pythonlocation\python.exe get-pip.py
$piplocation = "$env:SystemDrive\Python37\Scripts"

# Install needed libraries
. $piplocation\pip.exe install flask requests python-dotenv pylint matplotlib pillow requests-futures ordereddict pipenv dnspython astroid autopep8 azure-core azure-identity azure-mgmt-compute azure-mgmt-core azure-mgmt-storage PyInputPlus azure-mgmt-network azure-mgmt-resource azure-common
. $piplocation\pip.exe install --upgrade numpy
. $piplocation\pip.exe install requests --upgrade
. $piplocation\pip.exe install urllib3==1.26

# Add ROADTool
. $piplocation\pip.exe install roadrecon

# Add user to docker-users group
Add-LocalGroupMember -Group "docker-users" -Member "pentestadmin"

# Update Windows Subsystem for Linux
wsl --update