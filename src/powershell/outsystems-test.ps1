[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('10.0', '11')]
    [string]$MajorVersion = '11',

    [Parameter()]
    [string]$InstallDir = $("$env:ProgramFiles\OutSystems")
)

# -- Stop on any error
$ErrorActionPreference = 'Stop'

# -- Import module from Powershell Gallery
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force 
Install-Module -Name Outsystems.SetupTools -Force 

# -- Check HW and OS for compability
Test-OSServerHardwareReqs -MajorVersion $MajorVersion -Verbose -ErrorAction $ErrorActionPreference 
Test-OSServerSoftwareReqs -MajorVersion $MajorVersion -Verbose -ErrorAction $ErrorActionPreference 
