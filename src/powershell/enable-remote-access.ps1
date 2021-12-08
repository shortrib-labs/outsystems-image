# Enable WinRM
New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "WinRMCertificate"
Enable-PSRemoting -SkipNetworkProfileCheck -Force
($cert = gci Cert:\LocalMachine\My\) -and (New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $cert.Thumbprint –Force)

# Confirm the Firewall rule for WinRM is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "WinRM-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
      Write-Output "Firewall Rule 'WinRM-Server-In-TCP' does not exist, creating it..."
      New-NetFirewallRule -Name 'WinRM-Server-In-TCP' -DisplayName 'WinRM Server (https)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 5986
} else {
      Write-Output "Firewall rule 'WinRM-Server-In-TCP' has been created and exists."
}

Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true

# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Start-Service sshd

# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule for SSH is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
      Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
      New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
      Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

# make sure Powershell is the SSH shell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force


# enable RDP access
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
