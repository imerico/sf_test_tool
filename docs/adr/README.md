# ADR（Architecture Decision Record）

設計上の判断と、その理由を記録する場所です。運用の決定そのものは [0001](0001-ADRを使う.md) を参照してください。

## 書き方

1. 判断が必要な課題は、Issue フォーム「設計の検討（ADR 候補）」で起票する（任意）
2. [template.md](template.md) をコピーして `NNNN-タイトル.md` を作る
   - `NNNN` は、main にある最大の番号 + 1（4 桁、ゼロ埋め）
   - タイトルは日本語で可
3. 状態・関連 Issue・背景・決定・結果を書き、通常の PR で main に入れる
   - コミットの種類は `docs`（例: `docs: ADR 0002 データの保存先をファイルにする (#12)`）

## 状態

| 状態 | 意味 |
|---|---|
| 提案 | 検討中。PR のレビュー中など |
| 承認 | 決定済み。現在有効 |
| 廃止 | 取りやめた。理由を「結果」に追記する |
| 置き換え（ADR-NNNN） | 新しい ADR に置き換えた |

ADR のファイルは消さず、状態を変えて残します。

## 番号が重複したとき

`adr-number` チェックが失敗します。自分のブランチを最新にしてから振り直してください。

```bash
git fetch origin
git rebase origin/main
git mv docs/adr/0002-xxx.md docs/adr/0003-xxx.md   # ファイル内の番号も直す
git commit --amend    # またはコミットを追加
git push --force-with-lease
```

## 一覧

| 番号 | タイトル | 状態 |
|---|---|---|
| [0001](0001-ADRを使う.md) | 設計上の決定を ADR として記録する | 承認 |
