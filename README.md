# Gemini AI Commit Message Generator for czg

lazygitとczgを連携し、Gemini AIで自動的にコミットメッセージを生成する仕組みです。

## 🚀 セットアップ

### 1. 前提条件

- **Node.js** と **npm** がインストールされていること
- **czg** がインストールされていること
- **jq** (JSON処理用) がインストールされていること
- **curl** がインストールされていること

```bash
# macOSの場合
brew install jq

# czgのインストール (まだの場合)
npm install -g czg
```

### 2. Gemini API キーの取得

1. [Google AI Studio](https://aistudio.google.com/app/apikey) にアクセス
2. 「Create API Key」をクリックしてAPIキーを生成
3. APIキーをコピー

### 3. 環境変数の設定

APIキーを環境変数として設定します。シェルの設定ファイルに追加してください。

**Fish Shell の場合** (`~/.config/fish/config.fish`):
```fish
set -gx GEMINI_API_KEY "your-api-key-here"
```

**Bash/Zsh の場合** (`~/.bashrc` または `~/.zshrc`):
```bash
export GEMINI_API_KEY="your-api-key-here"
```

設定後、シェルをリロード：
```bash
# Fish
source ~/.config/fish/config.fish

# Bash
source ~/.bashrc

# Zsh
source ~/.zshrc
```

### 4. 動作確認

```bash
# APIキーが設定されているか確認
echo $GEMINI_API_KEY

# スクリプトのテスト（gitリポジトリ内で実行）
cd /path/to/your/git/repo
git add .
bash ~/.config/czg/gemini-commit.sh
```

## 📖 使い方

### 方法1: lazygit から使う（推奨）

1. lazygit を起動
2. ファイルをステージング
3. **`A`** キーを押す → AI が自動でコミットメッセージを生成
4. 生成されたメッセージを確認し、オプションを選択：
   - `1`: そのままコミット
   - `2`: czg で編集
   - `3`: キャンセル

または

1. lazygit を起動
2. ファイルをステージング
3. **`Z`** キーを押す → czg が起動
4. コミットメッセージ入力欄で **`:ai`** と入力 → AI が生成

### 方法2: コマンドラインから直接使う

```bash
# 変更をステージング
git add .

# AI生成コミット
czg-ai

# または通常のczgでAI生成
czg
# → subjectの入力時に :ai と入力
```

### 方法3: 手動でメッセージ生成のみ

```bash
# メッセージ生成のみ（コミットしない）
bash ~/.config/czg/gemini-commit.sh
```

## ⚙️ カスタマイズ

### Gemini モデルの変更

デフォルトでは `gemini-2.0-flash-exp` を使用していますが、変更可能です：

```bash
export GEMINI_MODEL="gemini-1.5-pro"
```

利用可能なモデル：
- `gemini-2.0-flash-exp` (デフォルト、高速)
- `gemini-1.5-pro` (高精度)
- `gemini-1.5-flash` (バランス型)

### プロンプトのカスタマイズ

`~/.config/czg/gemini-commit.sh` の `generate_commit_message()` 関数内のプロンプトを編集してください。

例：英語でメッセージを生成したい場合：

```bash
# 53行目あたりの日本語プロンプトを英語に変更
local prompt="You are an experienced software engineer. Analyze the following git diff and generate an appropriate commit message.

Requirements:
- Follow Conventional Commits format (type(scope): subject)
- Choose type from: feat, fix, docs, style, refactor, perf, test, chore, ci, build
- Keep subject concise and clear (recommended under 50 characters)
- Write in English
- Focus on the most important change if there are multiple changes
- Generate only the subject line, no body needed

Git Diff:
${diff}

Output only the commit message subject line."
```

### czg 設定のカスタマイズ

`~/.config/czg/.czrc` を編集して、czgの動作をカスタマイズできます：

```json
{
  "useEmoji": false,  // 絵文字を無効化
  "scopes": [         // プロジェクト固有のスコープを追加
    "api",
    "ui",
    "database"
  ]
}
```

## 🔧 トラブルシューティング

### API キーエラー

```
Error: GEMINI_API_KEY environment variable is not set
```

→ 環境変数が設定されていません。セットアップ手順の「3. 環境変数の設定」を確認してください。

### jq がない

```
command not found: jq
```

→ jqをインストールしてください：
```bash
brew install jq  # macOS
```

### 生成されたメッセージが空

- git diffが空でないか確認してください（`git diff --cached`）
- APIキーが有効か確認してください
- ネットワーク接続を確認してください

### czg が起動しない

```bash
# czgがインストールされているか確認
which czg

# なければインストール
npm install -g czg
```

## 📝 ファイル構成

```
~/.config/czg/
├── README.md              # このファイル
├── gemini-commit.sh       # Gemini API呼び出しスクリプト
├── ai-commit.js           # Node.jsラッパー
├── czg-ai                 # メインコマンド
└── .czrc                  # czg設定ファイル
```

## 💡 Tips

### エイリアスの設定

よく使うコマンドにエイリアスを設定すると便利です：

**Fish Shell**:
```fish
# ~/.config/fish/config.fish
alias gai='czg-ai'
alias gcz='czg'
```

**Bash/Zsh**:
```bash
# ~/.bashrc または ~/.zshrc
alias gai='czg-ai'
alias gcz='czg'
```

### AI生成をデフォルトに

lazygitで常にAIを使う場合、`config.yml`の`Z`キーを`czg-ai`に変更：

```yaml
customCommands:
  - key: "Z"
    context: "files"
    description: "AI Commit (Gemini)"
    command: "bash ~/.config/czg/czg-ai"
    output: terminal
```

### プロジェクトごとの設定

プロジェクトルートに `.czrc` を配置すると、そのプロジェクト専用の設定を使用できます。

## 🔗 参考リンク

- [czg Documentation](https://cz-git.qbb.sh/cli/)
- [Gemini API Documentation](https://ai.google.dev/docs)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [lazygit](https://github.com/jesseduffield/lazygit)

## 📄 ライセンス

MIT License
