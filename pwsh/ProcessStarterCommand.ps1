#設定主程式
if( $runEXE -eq $null){
  $runEXE = "ConsoleApp1.dll" 
}
#抓取執行路徑
$mypath = $MyInvocation.MyCommand.Path
Write-Output "Path of the script : $mypath"
$dirPath =  Split-Path $mypath -Parent
Write-Host $dirPath
cd $dirPath

. .\envfile.ps1
Write-Host $ProcessVersion

$rootPath=$dirPath


$fileExists = Test-Path -Path $rootPath\$ProcessVersion\$runEXE -PathType Leaf
Write-Host $rootPath\$ProcessVersion\$runEXE
Write-Host $fileExists
if($fileExists) {
    $runPS = "$rootPath/$ProcessVersion/$runEXE"
}else{
    Write-Host "沒有抓到版本抓取最新檔案"
    $a = Get-ChildItem -Filter $runEXE  -Recurse -ErrorAction SilentlyContinue -Force |  Sort-Object -Property LastWriteTime -Descending 

    $runPS = $a[0].FullName
}
Write-Host "抓到版本路徑: $runPS"

if( $JobName -eq $null){
  $JobName =  [System.IO.Path]::GetFileNameWithoutExtension($runEXE)
  Write-Host "JobName 沒有宣告，這邊使用程式名字: $JobName"
}

# 定義PID file路徑和文件名
$pidFile = "pid\$JobName.pid"

# 檢查PID file是否存在
if (Test-Path $pidFile) {
  # 如果PID file存在，則讀取PID file中的進程ID
  $pidId = Get-Content $pidFile

  # 檢查是否存在名稱為 $pidId 的進程
  $process = Get-Process -Id $pidId -ErrorAction SilentlyContinue
  if ($process) {
    # 如果存在，則不執行程式
    Write-Host '程式已經在運行中，不需要重複執行。'
  } else {
    # 如果不存在，則執行程式
    Write-Host '開始執行程式'
    #Start-Process -FilePath "$runPS" -ArgumentList $JobArg  -NoNewWindow -PassThru | Select-Object -ExpandProperty Id | Out-File $pidFile
    cd (Get-Item "$runPS").Directory.FullName
    $JobArgs = $JobArg -split " "
    dotnet $runEXE $JobArgs
    Write-Host '程式執行完成'
  }
} else {
  # 如果PID file不存在，則執行程式
    Write-Host '開始執行程式'
    #Start-Process -FilePath "$runPS" -ArgumentList $JobArg  -NoNewWindow -PassThru | Select-Object -ExpandProperty Id | Out-File $pidFile
    cd (Get-Item "$runPS").Directory.FullName
    $JobArgs = $JobArg -split " "
    dotnet $runEXE $JobArgs
    Write-Host '程式執行完成'
}




