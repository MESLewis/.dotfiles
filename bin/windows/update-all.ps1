
# Windows Update
Install-WindowsUpdate -Install -AcceptAll
# Powershell update
Update-Module
Update-Help -Force
# Ruby
gem update --system
gem update
# Node
npm install npm -g
npm update -g
# Chocolatey
choco update all -y