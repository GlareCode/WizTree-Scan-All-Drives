
##current ninjascript
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -ErrorVariable admin

if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
write-warning "Executing your script in 64-bit mode"
if ($myInvocation.Line) {
&"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile $myInvocation.Line
}else{
&"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile -file "$($myInvocation.InvocationName)" $args
}
exit $lastexitcode
}

$FileOut = "$env:temp\Scans$(Get-Date -Format 'MM_dd_yyyy').csv"
Set-Content "$FileOut" -Value "WizTreeScans" -Encoding UTF8

$wizPath = "$env:programfiles\WizTree\WizTree64.exe"
$File4 = "$(Get-Date -Format 'MM_dd_yyyy').csv"
$File3 = "$i$File4"
$File2 = "$env:temp"
$File1 = "$File2\$File3"

Get-wmiobject win32_volume | select-object name -expandproperty name | where-object -filterscript {$_.name -like "*:\*"} -outvariable Drives | Out-Null

for ( $i = 0 ; $i -lt $Drives.count; $i++ ){
    $DriveLetter = $Drives[$i];
    Start-Process -Filepath "$wizPath" -ArgumentList """$DriveLetter"" /export=""$File1"" /admin=1 /exportallsizes=1 /exportdrivecapacity=1 /exportmaxdepth=1 /exportfiles=0 /checkforupdates=false /sortby=2" -Verb runas -wait;
    $From = Get-Content -Path $File1;
    Add-Content -Path $FileOut -Value $From;
}
