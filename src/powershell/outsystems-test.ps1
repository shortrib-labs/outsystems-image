# Install OS Setup Tools and pre-requisites
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name OutSystems.SetupTools -Force

# Test that we meet hardware and software requirements
Test-OSServerHardwareReqs -MajorVersion 11
Test-OSServerSoftwareReqs -MajorVersion 11
