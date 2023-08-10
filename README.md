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