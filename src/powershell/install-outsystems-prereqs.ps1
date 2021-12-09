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

Install-OSServerPreReqs -MajorVersion $MajorVersion -Verbose -ErrorAction $ErrorActionPreference
