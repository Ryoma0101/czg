# 📚 Gemini AI Commit - ドキュメント目次

Gemini AIを使った自動コミットメッセージ生成システムへようこそ！

## 🚀 はじめに

### 初めての方
1. **[QUICKSTART.md](./QUICKSTART.md)** ← ここから始めてください！
   - 5分でセットアップ完了
   - 最初の一歩に最適

2. **[setup.sh](./setup.sh)** を実行
   ```bash
   bash ~/.config/czg/setup.sh
   ```

### すぐに使いたい方
**[CHEATSHEET.md](./CHEATSHEET.md)** - コマンドとキーバインドの一覧

---

## 📖 ドキュメント一覧

### 🎯 レベル別ガイド

| レベル | ドキュメント | 内容 | 所要時間 |
|--------|-------------|------|----------|
| 🌱 初心者 | [QUICKSTART.md](./QUICKSTART.md) | セットアップと基本的な使い方 | 5分 |
| 📝 日常使用 | [CHEATSHEET.md](./CHEATSHEET.md) | コマンド・キーバインド・Tips | 3分 |
| 📚 詳細 | [README.md](./README.md) | 完全なドキュメント | 15分 |
| 🏗️ 開発者 | [ARCHITECTURE.md](./ARCHITECTURE.md) | システム構造・カスタマイズ | 20分 |
| ⚙️ 設定 | [fish-config-example.fish](./fish-config-example.fish) | Fish Shell設定例 | 2分 |

---

## 🎯 目的別ガイド

### セットアップしたい
1. [QUICKSTART.md](./QUICKSTART.md) - セットアップ手順
2. `bash ~/.config/czg/setup.sh` - セットアップ実行
3. [fish-config-example.fish](./fish-config-example.fish) - シェル設定例

### 使い方を知りたい
- [CHEATSHEET.md](./CHEATSHEET.md) - 基本的な使い方
- [README.md](./README.md) の「使い方」セクション

### トラブルを解決したい
- [CHEATSHEET.md](./CHEATSHEET.md) の「トラブルシューティング」
- [README.md](./README.md) の「トラブルシューティング」
- `bash ~/.config/czg/setup.sh` で診断

### カスタマイズしたい
- [README.md](./README.md) の「カスタマイズ」セクション
- [ARCHITECTURE.md](./ARCHITECTURE.md) の「カスタマイズポイント」
- `.czrc` ファイルを編集

### 仕組みを理解したい
- [ARCHITECTURE.md](./ARCHITECTURE.md) - システム全体の構造
- ソースコード: `gemini-commit.sh`, `czg-ai`

---

## 📁 ファイル構成

```
~/.config/czg/
├── 📘 ドキュメント
│   ├── INDEX.md                  ← 今ここ！
│   ├── QUICKSTART.md             ← まずはここから
│   ├── CHEATSHEET.md             ← 日常使いの参照
│   ├── README.md                 ← 完全なガイド
│   ├── ARCHITECTURE.md           ← 技術詳細
│   └── fish-config-example.fish  ← 設定例
│
├── 🛠️ 実行ファイル
│   ├── gemini-commit.sh          ← AI生成コア
│   ├── czg-ai                    ← メインコマンド
│   ├── ai-commit.js              ← czg統合
│   └── setup.sh                  ← セットアップ
│
└── ⚙️ 設定
    └── .czrc                     ← czg設定
```

---

## ⚡ クイックスタート（30秒版）

```bash
# 1. APIキーを設定（初回のみ）
export GEMINI_API_KEY="your-api-key-here"

# 2. セットアップ実行（初回のみ）
bash ~/.config/czg/setup.sh

# 3. 使ってみる
cd /path/to/your/git/repo
git add .
bash ~/.config/czg/czg-ai

# または lazygit で 'A' キーを押す
```

---

## 💡 よくある質問

### Q: どのドキュメントから読めばいい？
**A:** [QUICKSTART.md](./QUICKSTART.md) から始めてください。5分で使えるようになります。

### Q: コマンドを忘れた
**A:** [CHEATSHEET.md](./CHEATSHEET.md) を参照してください。

### Q: エラーが出た
**A:** `bash ~/.config/czg/setup.sh` を実行してください。診断してくれます。

### Q: カスタマイズしたい
**A:** [ARCHITECTURE.md](./ARCHITECTURE.md) の「カスタマイズポイント」を参照。

### Q: 仕組みを知りたい
**A:** [ARCHITECTURE.md](./ARCHITECTURE.md) でシステム全体を解説しています。

---

## 🔗 外部リンク

- **Gemini API**: https://aistudio.google.com/app/apikey
- **czg**: https://cz-git.qbb.sh/cli/
- **Conventional Commits**: https://www.conventionalcommits.org/
- **lazygit**: https://github.com/jesseduffield/lazygit

---

## 📝 使用例

### lazygit から使う（推奨）
1. lazygit起動
2. ファイルをステージング
3. `A` キーを押す
4. AIが生成したメッセージを確認
5. オプションを選択してコミット

### コマンドラインから
```bash
git add .
bash ~/.config/czg/czg-ai
```

---

## 🎓 学習パス

```
┌─────────────────────────────────────────────┐
│  1. QUICKSTART.md                           │
│     ↓ セットアップと基本使用                │
│  2. CHEATSHEET.md                           │
│     ↓ よく使うコマンドを覚える              │
│  3. README.md                               │
│     ↓ 詳細な機能とカスタマイズ              │
│  4. ARCHITECTURE.md                         │
│     ↓ 仕組みを理解して高度なカスタマイズ    │
│  5. ソースコードを読む                      │
│     ↓ 完全にマスター！                      │
└─────────────────────────────────────────────┘
```

---

## 🆘 サポート

問題が発生した場合：

1. **診断実行**: `bash ~/.config/czg/setup.sh`
2. **ドキュメント確認**: [README.md](./README.md) のトラブルシューティング
3. **設定確認**: `echo $GEMINI_API_KEY` でAPIキーをチェック

---

**バージョン**: 1.0.0
**最終更新**: 2024-10-24

**次のステップ**: [QUICKSTART.md](./QUICKSTART.md) を開いて、5分でセットアップしましょう！
