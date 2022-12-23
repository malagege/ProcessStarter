# 放置下面兩個參數
$JobName="JobName2"
$JobArg="JobName2 arg1 arg2 arg3"
# 可以指定要執行哪個
# 預設為執行 ProcessStarter.ps1
#$runEXE="HelloWorld.exe" 

cd (Convert-Path .)
#Write-Host $pwd
$mypath = $MyInvocation.MyCommand.Path
#Write-Output "Path of the script : $mypath"
$dirPath =  Split-Path $mypath -Parent
#Write-Host $dirPath
cd $dirPath
#Write-Host $pwd
Invoke-Expression ../ProcessStarter.ps1