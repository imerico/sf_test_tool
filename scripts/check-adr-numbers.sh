#!/usr/bin/env bash
# ADR のファイル名と番号の重複をチェックする（docs/adr/README.md 参照）
#
#   使い方: scripts/check-adr-numbers.sh [ADR ディレクトリ]
set -euo pipefail
export LC_ALL=C.UTF-8

dir=${1:-docs/adr}
[[ -d $dir ]] || { echo "ADR ディレクトリがありません: $dir"; exit 0; }

status=0
declare -A seen=()
while IFS= read -r -d '' path; do
  name=${path##*/}
  case $name in README.md|template.md) continue ;; esac
  if [[ ! $name =~ ^([0-9]{4})-.+\.md$ ]]; then
    echo "✖ ファイル名が NNNN-タイトル.md の形式ではありません: $path" >&2
    status=1
    continue
  fi
  num=${BASH_REMATCH[1]}
  if [[ -n ${seen[$num]:-} ]]; then
    echo "✖ ADR 番号 $num が重複しています: ${seen[$num]} と $path" >&2
    echo "  git rebase main で最新にしてから、空いている番号に振り直してください。" >&2
    status=1
  else
    seen[$num]=$path
  fi
done < <(find "$dir" -maxdepth 1 -type f -print0 | sort -z)

(( status == 0 )) && echo "✔ ADR の番号に問題はありません（${#seen[@]} 件）"
exit $status
