#!/bin/bash
source envfile.sh

#
# Check if file exists
if [ -f "$rootPath/$ProcessVersion/$runEXE" ]; then
  runPS="$ProcessVersion/$runEXE"
else
  echo "沒有抓到版本抓取最新檔案"
  # Find and sort files by last modified time
  a=$(find . -name "$runEXE" -type f -print0 | xargs -0 ls -lt | sort -r)
  # Get first file in the list
  runPS=$(echo "$a" | head -n 1 | awk '{print $NF}')
fi
echo "抓到版本路徑: $runPS"


# JobName Pid 預設
if [[ -z $JobName ]]; then
    JobName=$runEXE
fi


# 行程 ID 檔案路徑
PID_FILE=./pid/${JobName}.pid

# 檢查行程 ID 檔案是否存在
if [ -f $PID_FILE ]; then
  # 取得行程 ID
  PID=$(cat $PID_FILE)

  # 檢查行程是否有在執行
  ps -p $PID > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "This script is already running!"
    exit 1
  fi
fi

# 行程沒有在執行，將目前行程 ID 寫入檔案
echo $$ > $PID_FILE

# 檢查行程 ID 檔案是否成功被建立
if [ $? -ne 0 ]; then
  echo "Could not create PID file."
  exit 1
fi

# 主要工作
echo "Doing my job."
dotnet $runPS $JobArg
sleep 30s

echo "Done."

# 刪除鎖定檔案
rm -f ${PID_FILE}