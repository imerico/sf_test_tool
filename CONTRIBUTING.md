# 開発ルール

## 最初にやること（各環境で 1 回）

```bash
git clone https://github.com/imerico/sf_test_tool.git
cd sf_test_tool
git config core.hooksPath .githooks   # コミットメッセージを手元でチェックする hook を有効化
```

確認方法：`git commit --allow-empty -m "テスト"` が弾かれれば有効です。

## 作業の流れ

1. **Issue を作る** — すべての作業に Issue が必要です（フォームは「作業」「設計の検討（ADR 候補）」の 2 種類）
2. **ブランチを作る** — main から作業ブランチを作る（名前は自由。例: `fix/12-draft-restore`）
3. **コミットする** — 下の「コミットメッセージ」の規約に従う
4. **PR を作る** — 本文に `Closes #12` のように Issue 番号を書く
5. **チェックが通ったらマージ** — 「Rebase and merge」でマージする（承認は不要）

### main のルール

main は保護されていて、管理者も例外なく次のルールに従います。

- 直接 push できない（PR 経由のみ）
- マージは Rebase のみ。履歴は一直線
- 強制 push・削除はできない
- 次のチェックがすべて成功していないとマージできない

| チェック | 内容 |
|---|---|
| `build` | `quiz_app` で exe をビルドできるか（できた exe は Actions の成果物からダウンロード可） |
| `issue-link` | PR 本文に実在する Issue への参照（`Closes` / `Fixes` / `Resolves` / `Refs` + `#番号`）があるか |
| `adr-number` | ADR のファイル名が `NNNN-タイトル.md` で、番号が重複していないか |
| `commit-message` | PR の全コミットのメッセージが規約に合っているか。マージコミットを含まないか |

### 作業ブランチを main に追従させる

作業ブランチは強制 push できるので、rebase で追従します（マージコミットは `commit-message` チェックで不合格になります）。

```bash
git fetch origin
git rebase origin/main
git push --force-with-lease   # 他の人の push を消さない安全な強制 push
```

## コミットメッセージ

```
<種類>(<範囲>)!: <説明> (#<Issue番号>)

<本文（任意）>
```

- **種類**（必須）

  | 種類 | 使う場面 |
  |---|---|
  | `feat` | 機能の追加 |
  | `fix` | 不具合の修正 |
  | `data` | 問題データの追加・修正 |
  | `docs` | ドキュメント・ADR |
  | `style` | 見た目だけの変更（動きは変わらない） |
  | `refactor` | 動きを変えないコードの整理 |
  | `perf` | 速度の改善 |
  | `test` | テスト |
  | `build` | ビルド・依存パッケージ |
  | `ci` | GitHub Actions・チェック用スクリプト |
  | `chore` | その他の雑務 |
  | `revert` | 取り消し |

- **範囲**（任意）：`feat(quiz_app): …` のように変更した場所
- **`!`**（任意）：互換性を壊す変更（例：保存データの形式が変わる）
- **説明**：日本語で
- **Issue 番号**：1 行目の末尾に `(#番号)` が必須
- **1 行目は 72 文字まで**（日本語も 1 文字として数える）
- 本文を書くときは 1 行目の後に空行を入れる

例：

```
feat: 制限時間つきモードを追加 (#3)
fix: 途中保存が復元されない不具合を修正 (#12)
data: 問題12の正解を修正 (#15)
docs: ADR 0002 データの保存先をファイルにする (#16)
```

`fixup!` / `squash!` のコミットは手元では作れますが、PR に残っていると `commit-message` チェックが失敗します。`git rebase -i --autosquash origin/main` でまとめてから push してください。

規約違反のコミットを直すには：

```bash
git commit --amend                # 直前のコミット
git rebase -i origin/main         # それより前のコミット（reword を選ぶ）
git push --force-with-lease
```

## ADR

設計上の判断は `docs/adr/` に ADR として記録します。書き方は [docs/adr/README.md](docs/adr/README.md) を参照してください。
