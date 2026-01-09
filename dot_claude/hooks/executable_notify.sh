#!/bin/bash

# Claude Code通知スクリプト
# 許可待ち・入力待ち・タスク完了時にMac通知を送る

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
project=$(basename "$cwd")
notification_type=$(echo "$input" | jq -r '.notification_type')

case "$notification_type" in
  "permission_prompt")
    terminal-notifier -title "Claude Code" -subtitle "$project" -message "許可待ち" -sound "Ping"
    ;;
  "idle_prompt")
    terminal-notifier -title "Claude Code" -subtitle "$project" -message "入力待ち" -sound "Purr"
    ;;
  "stop")
    terminal-notifier -title "Claude Code" -subtitle "$project" -message "タスク完了" -sound "Glass"
    ;;
esac
