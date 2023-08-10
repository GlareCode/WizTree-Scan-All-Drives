<#

    .SYNOPSIS
    Installs Chocolatey
    Installs WizTree via Chocolatey
    Scans Drives with Wiztree
    Outputs the files in admin user TEMP directory

    .DESCRIPTION
    Automatically installes and runs wiztree with this one script.

    .OUTPUTS
    "**************Please reopen PowerShell as Administrator***************"
    "Executing your script in 64-bit mode"
    "Chocolatey not installed"
    "Chocolatey already installed"
    "Installing Chocolatey"
    "Wiztree already installed"
    "Wiztree not installed"


    .EXAMPLE
    PS> Find-Choco
    PS> ./WiztreeMultiScanner.ps1

    .REFERENCES

    https://community.spiceworks.com/topic/2203658-check-if-choco-already-installed-and-install-if-not
    https://community.chocolatey.org/packages/wiztree
    
#>

# Check if ran as Administrator----------------------------------------------------------

$gotchya = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

if ($gotchya -eq $False){
    Write-Host "**************Please reopen PowerShell as Administrator***************"
    Write-Host "**************Please reopen PowerShell as Administrator***************"
    Write-Host "**************Please reopen PowerShell as Administrator***************"
    
    $exit = Read-Host "Press 0 to Exit"

    if ($exit -ne 0){
        stop-process -id $PID
    }Else{
        stop-process -id $PID
    }

}


if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    write-warning "Executing your script in 64-bit mode"
    if ($myInvocation.Line) {
        &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile $myInvocation.Line
    }else{
        &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile -file "$($myInvocation.InvocationName)" $args
    }
    exit $lastexitcode

}


function Out-Data{
    $wizPath = "$env:programfiles\WizTree\WizTree64.exe"

    $FileOut = "$env:temp\Scans-$(Get-Date -Format 'MM_dd_yyyy').csv"
    Set-Content "$FileOut" -Value "WizTreeScans" -Encoding UTF8
    
    $File5 = "ScanImage.png"
    $File5Path = "$env:temp\$File5"
    $File4 = "Scans-$(Get-Date -Format 'MM_dd_yyyy').csv"
    $File3 = "$i$File4"
    $File2 = "$env:temp"
    $File1 = "$File2\$File3"

    Get-wmiobject win32_volume | select-object name -expandproperty name | where-object -filterscript {$_.name -like "*:\*"} -OutVariable drives -ErrorAction SilentlyContinue | Out-Null

    if ($drives.count -eq "1"){
        $i = 0
        $DriveLetter = $Drives[$i]
        Start-Process -Filepath "$wizPath" -ArgumentList """$DriveLetter"" /export=""$File1"" /admin=1 /exportallsizes=1 /exportdrivecapacity=1 /exportmaxdepth=2 /exportfiles=0 /checkforupdates=false /sortby=2 /treemapimagefile=$File5Path" -Verb runas -wait
        $From = Get-Content -Path $File1
        Add-Content -Path $FileOut -Value $From

    }ElseIf ($drives.count -gt "1"){
        for ($i = 0; $i -lt $Drives.count; $i++){
        $DriveLetter = $Drives[$i]
        Start-Process -Filepath "$wizPath" -ArgumentList """$DriveLetter"" /export=""$File1"" /admin=1 /exportallsizes=1 /exportdrivecapacity=1 /exportmaxdepth=2 /exportfiles=0 /checkforupdates=false /sortby=2 /treemapimagefile=$File5Path" -Verb runas -wait
        $From = Get-Content -Path $File1
        Add-Content -Path $FileOut -Value $From
        }
    
    }

    Write-Host "Wiztree output located in "$env:temp\Scans-date""
    return

}


function Find-WizTree {
    $testChoco = choco list wiztree

    $table = New-Object System.Data.Datatable
    [void]$table.Columns.Add("Num")
    [void]$table.Columns.Add("Name")

    for ( $i = 0; $i -lt $testchoco.count; $i ++){
        [void]$table.Rows.Add("$i",$testchoco[$i])
    }

    $findWiz = $table | Where-Object Name -Match "(.*)wiztree" | Select-Object -ExpandProperty name 
    $isnull = [string]::IsNullOrEmpty($findWiz)

    if ($isnull -eq $False){
        Write-Host "Wiztree already installed"
    }Else{
        Write-Host "Wiztree not installed"
        choco install wiztree -y
    }
    # Move to Out-Data Function
    return Out-Data

}


function Find-Choco {
    try {
        $errorActionPreference = 'Stop'
        choco -v
    }
    catch {
        Write-Host "Chocolatey not installed"
        $ErrorOccured=$true
    }

    If(!$ErrorOccured){
        Write-Host "Chocolatey already installed"
        return Find-WizTree
    }Else{
        Write-Host "Installing Chocolatey"
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        return Find-WizTree
    }

}


Find-Choco
