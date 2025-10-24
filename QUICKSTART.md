# 🚀 クイックスタート

Gemini AIを使った自動コミットメッセージ生成を5分でセットアップ！

## 📋 前提条件

以下がインストールされていることを確認してください：

- Node.js & npm
- czg (`npm install -g czg`)
- jq (`brew install jq`)

## ⚡ セットアップ（3ステップ）

### 1️⃣ Gemini API キーを取得

[https://aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey) にアクセスして、APIキーを作成

### 2️⃣ 環境変数を設定

```bash
# Fish Shell
set -gx GEMINI_API_KEY "your-api-key-here"

# Bash/Zsh
export GEMINI_API_KEY="your-api-key-here"
```

シェルの設定ファイルに追加することを推奨：
- Fish: `~/.config/fish/config.fish`
- Zsh: `~/.zshrc`
- Bash: `~/.bashrc`

### 3️⃣ セットアップスクリプトを実行

```bash
bash ~/.config/czg/setup.sh
```

## 🎯 使い方

### lazygit から使う（最も簡単）

1. **lazygit** を起動
2. 変更をステージング（スペースキー）
3. **`A`** キーを押す
4. AIが自動でコミットメッセージを生成！
5. オプションを選択：
   - `1`: そのままコミット
   - `2`: czgで編集
   - `3`: キャンセル

### コマンドラインから使う

```bash
# 変更をステージング
git add .

# AI生成＋コミット
bash ~/.config/czg/czg-ai
```

## 🧪 テスト

動作を確認してみましょう：

```bash
# 1. テスト用リポジトリを作成
cd /tmp
mkdir test-ai-commit
cd test-ai-commit
git init

# 2. テストファイルを作成
echo "function hello() { console.log('Hello'); }" > hello.js

# 3. ステージング
git add hello.js

# 4. AI生成を実行
bash ~/.config/czg/czg-ai
```

期待される出力：
```
🤖 AI Commit Message Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 Analyzing changes...

✨ Generated commit message:
feat: hello関数を追加

Options:
  1) Use this message and commit
  2) Edit with czg
  3) Cancel
Choose [1-3]:
```

## 💡 Tips

### エイリアスを設定

頻繁に使う場合は、エイリアスを設定すると便利：

```bash
# Fish
alias gai='bash ~/.config/czg/czg-ai'

# Bash/Zsh
alias gai='bash ~/.config/czg/czg-ai'
```

使用例：
```bash
git add .
gai  # AI生成＋コミット！
```

### プロンプトをカスタマイズ

`~/.config/czg/gemini-commit.sh` の50行目付近を編集して、プロンプトをカスタマイズできます。

例：英語でメッセージを生成
```bash
local prompt="Generate a concise commit message in English for the following changes..."
```

### 使用するモデルを変更

```bash
# より高精度なモデルを使用
export GEMINI_MODEL="gemini-1.5-pro"

# デフォルト（高速）に戻す
export GEMINI_MODEL="gemini-2.0-flash-exp"
```

## 🔧 トラブルシューティング

### "GEMINI_API_KEY is not set"

→ 環境変数が設定されていません。シェルをリロードしてください：

```bash
# Fish
source ~/.config/fish/config.fish

# Bash
source ~/.bashrc

# Zsh
source ~/.zshrc
```

### "command not found: jq"

→ jqをインストールしてください：

```bash
brew install jq
```

### "command not found: czg"

→ czgをインストールしてください：

```bash
npm install -g czg
```

### APIエラーが出る

1. APIキーが正しいか確認
2. ネットワーク接続を確認
3. APIの利用制限を確認（無料枠の場合）

## 📚 次のステップ

- [README.md](./README.md) - 詳細なドキュメント
- [Conventional Commits](https://www.conventionalcommits.org/) - コミットメッセージの規約
- [czg Documentation](https://cz-git.qbb.sh/cli/) - czgの詳細

## 🎉 完了！

これで、lazygitから`A`キーを押すだけでAIがコミットメッセージを生成してくれます！

質問や問題がある場合は、[README.md](./README.md)の「トラブルシューティング」セクションを確認してください。
