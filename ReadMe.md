# 程式排成啟動器

**因為我不是專長寫 Powershell 和 Shell Script ，所以請斟酌再使用**

這是一個可以控制簡單排成程式啟動器，可以防止程式重複執行，假如要更新程式不需要暫停所有執行中程式，可以放置新的路徑，修改版本設定，下次排程執行就可以執行新程式。

## 製作原因

其實我是有看到 [PowerShell 防止同時執行程式(使用Mutex) - 程式狂想筆記 - 記錄著我接觸程式藝文](https://malagege.github.io/blog/posts/PowerShell-%E9%98%B2%E6%AD%A2%E5%90%8C%E6%99%82%E5%9F%B7%E8%A1%8C%E7%A8%8B%E5%BC%8F-%E4%BD%BF%E7%94%A8Mutex/) 方法，但是很大機率這個方法會死鎖，重開機才能解決我的問題。所以就放棄這個方法。這邊原本想用 supervisord ，但發現這個不適合做排程，畢竟我一天只要跑一次就沒必要用到 supervisord。這邊後來乖乖用 Window 內建排程器，但一般我們專案會固定一個 Main 方法，針對不同參數。這邊不管你是寫 Net Core 還是 Java 理論上都可以使用執行。但包在一起程式假如做更新程式時候，勢必要把所有排程停掉，這部分非常麻煩。透過放置新程式，這邊只要去改檔案變數就可以解決更新問題，下次排程就會指定新的路徑。


## 日誌問題

日誌是由程式控制的，一般可能會放在固定位置。但你寫再參照位置，日誌會寫在 command 呼叫指令路徑上面，，預設會再 `pwsh`或`shell`上面，這樣設置是方便的，不管版本日誌都會寫在同一個地方。假如你是寫死 log 路徑，你可以略過這個。

## 主要功能

1. 防止重複執行
2. 手動更新程式，不影響舊程式執行
3. 設定檔沒有抓到程式路徑，程式會尋找最新檔案路徑去執行


## 操作設定

### Window

1. 設定檔(envfile.ps1)
```ps1
# Process Ver
$ProcessVersion = "v1"
```
這邊設定檔會對照執行排程資料夾，Windows 大小寫不分，但建議一致。

2. 啟動程式
這邊會有 JobName 和 Command，差異一個為單純 GUI 啟動，後者為 Command 指令啟用，我們要調整兩個地方。

```ps1
if( $runEXE -eq $null){
  $runEXE = "HelloWorld.exe" 
}

```

GUI 應該不會調整這個東西。
```ps1
    Write-Host '開始執行程式'
    $JobArgs = $JobArg -split " "
    dotnet $runPS $JobArgs
    Write-Host '程式執行完成'
  }
} else {
  # 如果PID file不存在，則執行程式
    Write-Host '開始執行程式'

    $JobArgs = $JobArg -split " "
    dotnet $runPS $JobArgs
    Write-Host '程式執行完成'

```

其中 `dotnet $runPS`可以改成你指令要執行東西。


3. 執行程式(HelloWorldJobName1.ps1)

排程主程式要帶進去參數。我們也可指定要執行 runEXE 程式。

::: Tips 
這邊當然也可寫死或者用腳本帶日期進去，正常排程都會帶時間進去，讓我們可以方便可以補跑排程。
:::


```ps1
# 放置下面兩個參數
$JobName="JobName1"
$JobArg="JobName1 arg1 arg2 arg3"
# 可以指定要執行哪個
# 預設為執行 ProcessStarter.ps1
#$runEXE="HelloWorld.exe" 

```

    1. `JobName` 通常都排程名稱維一值。這個是排程主程式帶進去名稱，這個是附止重覆執行 pid 名稱，沒有帶預設以主程式為主。
    2. `JobArg` 主程式執行帶進去參數
    3. `runEXE` 執行主程式，這邊可以自己設定。ProcessStarter和有ProcessStarterCommand都有設定。請參考步驟2


### Linux

1. 設定檔
```sh
ProcessVersion="v1";
echo "Process envfile Version: $ProcessVersion";
runEXE="ConsoleApp1.dll"
```
    1. `ProcessVersion` 是版本這邊設定檔會對照執行排程資料夾。
    2. `runEXE`預設排程主程式名稱。

2. 執行程式(HelloWorldJobName1.sh)

```bash
JobName="Command1"
#runEXE=""
JobArg="Command1 arg1 arg2 arg3"

```

    1. `JobName`通常都排程名稱維一值。這個是排程主程式帶進去名稱，這個是附止重覆執行 pid 名稱，沒有帶預設以主程式為主。
    2. `runEXE` 執行主程式，這邊可以自己設定。ProcessStarter和有ProcessStarterCommand都有設定。
    3. `JobArg` 主程式執行帶進去參數

