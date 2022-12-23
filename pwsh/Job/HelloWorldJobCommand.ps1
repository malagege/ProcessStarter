# 放置下面兩個參數
$JobName="Command1"
$JobArg="Command1 arg1 arg2 arg3"
# 可以指定要執行哪個
# 預設為執行 ProcessStarterCommand.ps1
#$runEXE="ConsoleApp1.exe" 

cd (Convert-Path .)
#Write-Host $pwd
$mypath = $MyInvocation.MyCommand.Path
#Write-Output "Path of the script : $mypath"
$dirPath =  Split-Path $mypath -Parent
#Write-Host $dirPath
cd $dirPath
#Write-Host $pwd
Invoke-Expression ../ProcessStarterCommand.ps1