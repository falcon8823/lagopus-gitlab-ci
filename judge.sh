#!/bin/sh

# Ryuのテスターはテストが完了しても終了しないため、
# この監視スクリプトでsuccess or failedの判定をする

MAX_TIME=${MAX_TIME:-120}

# logが流れるようにバックグラウンド動作
docker logs -f $RYU_NAME &
log_pid=$!

# MAX_TIMEまでログを監視
for i in `seq 1 $MAX_TIME`; do
  sleep 1

  # 終了チェック
  docker logs $RYU_NAME 2>&1 | grep  'Test report' 1> /dev/null
  if test $? = 0; then
    # OKとエラーの数を取得
    result=`docker logs $RYU_NAME 2>&1 | grep 'OK\(.*\) / ERROR\(.*\)'`
    ok_num=`echo "$result" | sed -e "s/OK(\(.*\)) \/ ERROR(\(.*\))/\1/"`
    ng_num=`echo "$result" | sed -e "s/OK(\(.*\)) \/ ERROR(\(.*\))/\2/"`

    # docker logsでログを表示していたプロセスをkill
    kill $log_pid

    # NGが0でなければエラー(failed),そうでなければ正常終了(success)
    if test $ng_num != 0; then
      exit 1
    else
      exit 0
    fi
  fi
done
