# sf_test_tool

Salesforce 資格試験の過去問トレーナーです。

| ディレクトリ | 内容 |
|---|---|
| `quitz_tool/` | アプリ本体（`問題.html`。ブラウザで開くだけで動く） |
| `quiz_app/` | `問題.html` を Windows 用 exe にするプロジェクト（Neutralinojs）。[README](quiz_app/README.md) |
| `docs/adr/` | 設計上の決定の記録（[ADR](docs/adr/README.md)） |

## 開発に参加する

ブランチ・Issue・PR・コミットメッセージのルールは [CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。

clone したら、最初に次を実行してください（コミットメッセージのチェック用 hook を有効にします）。

```bash
git config core.hooksPath .githooks
```
