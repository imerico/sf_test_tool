#!/usr/bin/env bash
# コミットメッセージの規約チェック（CONTRIBUTING.md「コミットメッセージ」参照）
#
#   使い方: scripts/check-commit-msg.sh <メッセージファイル> [--ci]
#
#   - 手元の commit-msg hook と CI（commit-message チェック）の両方から呼ばれる
#   - --ci のときは fixup! / squash! / amend! や Merge コミットも不合格にする
set -euo pipefail
export LC_ALL=C.UTF-8 # 日本語も 1 文字として数えるため

file=${1:?メッセージファイルを指定してください}
mode=${2:-}

TYPES='feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert|data'
MAX_LEN=72
pattern="^(${TYPES})(\([^()]+\))?!?: .+ \(#[0-9]+\)$"

# git が取り除くコメント行（# で始まる行）と、--verbose の差分以降を除いた本文
msg=$(sed '/^# -\{24\} >8 -\{24\}$/,$d' "$file" | grep -v '^#' || true)
subject=$(printf '%s\n' "$msg" | sed -n '1p')
second=$(printf '%s\n' "$msg" | sed -n '2p')

# 手元での一時的なコミットは hook では通す（CI では不合格）
if [[ $mode != --ci ]]; then
  if [[ $subject =~ ^(fixup|squash|amend)!\  || $subject =~ ^Merge\  ]]; then
    exit 0
  fi
fi

errors=()
if [[ ! $subject =~ $pattern ]]; then
  errors+=("1 行目が形式に合っていません。")
fi
if (( ${#subject} > MAX_LEN )); then
  errors+=("1 行目が ${#subject} 文字です（上限 ${MAX_LEN} 文字）。")
fi
if [[ -n $second ]]; then
  errors+=("本文を書く場合は、1 行目の後に空行を 1 行入れてください。")
fi

if (( ${#errors[@]} > 0 )); then
  {
    echo "✖ コミットメッセージが規約に合っていません"
    echo "  1 行目: ${subject}"
    for e in "${errors[@]}"; do echo "  - $e"; done
    echo
    echo "  形式: <種類>(<範囲>)!: <説明> (#<Issue番号>)   ※ (<範囲>) と ! は任意"
    echo "  種類: ${TYPES//|/ }"
    echo "  例  : fix: 途中保存が復元されない不具合を修正 (#12)"
  } >&2
  exit 1
fi
