oh-my-posh init pwsh --config "$HOME/my-omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine
Set-PsReadLineOption -PredictionSource History
Set-PsReadLineOption -PredictionVIewStyle ListView
Set-PsReadLineOption -EditMode Windows
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# Basic commands
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }

# Common Editing needs
function Edit-Hosts { Invoke-Expression "sudo $(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $env:windir\system32\drivers\etc\hosts" }
function Edit-Profile { Invoke-Expression "$(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $profile" }

# Sudo
function sudo() {
    if ($args.Length -eq 1) {
        start-process $args[0] -verb "runAs"
    }
    if ($args.Length -gt 1) {
        start-process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
    }
}

# System Update - Update RubyGems, NPM, and their installed packages
function System-Update() {
    Install-WindowsUpdate -IgnoreUserInput -IgnoreReboot -AcceptAll
    Update-Module
    Update-Help -Force
    gem update --system
    gem update
    npm install npm -g
    npm update -g
}

# Reload the Shell
function Reload-Powershell {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = "-nologo";
    [System.Diagnostics.Process]::Start($newProcess);
    exit
}

# Download a file into a temporary folder
function curlex($url) {
    $uri = new-object system.uri $url
    $filename = $name = $uri.segments | Select-Object -Last 1
    $path = join-path $env:Temp $filename
    if( test-path $path ) { rm -force $path }

    (new-object net.webclient).DownloadFile($url, $path)

    return new-object io.fileinfo $path
}

# Empty the Recycle Bin on all drives
function Empty-RecycleBin {
    $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
    $RecBin.Items() | %{Remove-Item $_.Path -Recurse -Confirm:$false}
}
