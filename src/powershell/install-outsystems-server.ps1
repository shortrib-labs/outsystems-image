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

Install-OSServer -Version $(Get-OSRepoAvailableVersions -MajorVersion $MajorVersion -Application 'PlatformServer' -Latest) -InstallDir $InstallDir -Verbose -ErrorAction $ErrorActionPreference
