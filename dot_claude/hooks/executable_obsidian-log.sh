#!/bin/bash
# Claude Code Obsidian Logger
# 全作業をObsidianの日付別ファイルに記録

LOG_DIR="/Users/MatsumuraSatoshi/Documents/oshigoto/claudework"
TODAY=$(date +"%Y-%m-%d")
LOG_FILE="${LOG_DIR}/${TODAY}.md"
TIMESTAMP=$(date +"%H:%M:%S")

# 入力をJSONとして読み取り
INPUT=$(cat)

# JSONからフィールドを抽出
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "N/A"')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"' | cut -c1-8)
CWD=$(echo "$INPUT" | jq -r '.cwd // "unknown"')

# ログファイルが存在しない場合、ヘッダーを作成
if [ ! -f "$LOG_FILE" ]; then
    cat > "$LOG_FILE" << EOF
---
date: ${TODAY}
tags: [claude-work, daily-log]
---

# Claude Work Log - ${TODAY}

EOF
fi

# イベントに応じてログを記録
case "$HOOK_EVENT" in
    "SessionStart")
        echo "" >> "$LOG_FILE"
        echo "## 🚀 Session Start - ${TIMESTAMP}" >> "$LOG_FILE"
        echo "- **Session ID**: \`${SESSION_ID}\`" >> "$LOG_FILE"
        echo "- **Working Dir**: \`${CWD}\`" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
        ;;
    "PreToolUse")
        # 重要なツールのみ記録（ノイズ軽減）
        case "$TOOL_NAME" in
            "Bash"|"Write"|"Edit"|"Task"|"mcp__"*)
                echo "- ⏳ \`${TIMESTAMP}\` **${TOOL_NAME}** 実行開始" >> "$LOG_FILE"
                ;;
        esac
        ;;
    "PostToolUse")
        case "$TOOL_NAME" in
            "Bash"|"Write"|"Edit"|"Task"|"mcp__"*)
                TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // {}')
                # Bashコマンドの場合、コマンド内容を記録
                if [ "$TOOL_NAME" = "Bash" ]; then
                    CMD=$(echo "$TOOL_INPUT" | jq -r '.command // "N/A"' | head -c 200)
                    echo "  - ✅ 完了: \`${CMD}\`" >> "$LOG_FILE"
                # ファイル操作の場合、パスを記録
                elif [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
                    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // "N/A"')
                    echo "  - ✅ 完了: \`${FILE_PATH}\`" >> "$LOG_FILE"
                else
                    echo "  - ✅ 完了" >> "$LOG_FILE"
                fi
                ;;
        esac
        ;;
    "SessionEnd")
        echo "" >> "$LOG_FILE"
        echo "## 🏁 Session End - ${TIMESTAMP}" >> "$LOG_FILE"
        echo "- **Session ID**: \`${SESSION_ID}\`" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
        echo "---" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
        ;;
    "Stop")
        echo "" >> "$LOG_FILE"
        echo "### ⏹️ Task Completed - ${TIMESTAMP}" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
        ;;
esac

exit 0
