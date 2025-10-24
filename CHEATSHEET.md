# 🎯 チートシート - Gemini AI Commit

## 🚀 クイックリファレンス

### セットアップ（初回のみ）

```bash
# 1. APIキーを設定
export GEMINI_API_KEY="your-api-key-here"

# 2. シェル設定に追加
echo 'set -gx GEMINI_API_KEY "your-api-key-here"' >> ~/.config/fish/config.fish  # Fish
echo 'export GEMINI_API_KEY="your-api-key-here"' >> ~/.zshrc                    # Zsh

# 3. セットアップ実行
bash ~/.config/czg/setup.sh
```

---

## 💻 使い方

### lazygit から

| キー | 動作        | 説明                        |
| ---- | ----------- | --------------------------- |
| `A`  | AI コミット | AIが自動生成→選択肢から選ぶ |
| `Z`  | czg起動     | subject入力で`:ai`と入力    |

### コマンドライン

```bash
# パターン1: AIコミット（インタラクティブ）
git add .
bash ~/.config/czg/czg-ai

# パターン2: メッセージ生成のみ
git add .
bash ~/.config/czg/gemini-commit.sh

# パターン3: czgを直接起動
czg  # subject入力時に :ai と入力
```

---

## ⚙️ 設定

### 環境変数

```bash
# 必須
export GEMINI_API_KEY="your-api-key"

# オプション
export GEMINI_MODEL="gemini-2.0-flash-exp"  # デフォルト
export GEMINI_MODEL="gemini-1.5-pro"        # 高精度
export GEMINI_MODEL="gemini-1.5-flash"      # バランス
```

### エイリアス（推奨）

```bash
# Fish Shell
alias gai='bash ~/.config/czg/czg-ai'
alias gcz='czg'
alias gaimsg='bash ~/.config/czg/gemini-commit.sh'

# Bash/Zsh
alias gai='bash ~/.config/czg/czg-ai'
alias gcz='czg'
alias gaimsg='bash ~/.config/czg/gemini-commit.sh'
```

---

## 🎨 Conventional Commits 形式

### Type一覧

| Type       | 説明             | 例                               |
| ---------- | ---------------- | -------------------------------- |
| `feat`     | 新機能           | `feat(auth): ログイン機能を追加` |
| `fix`      | バグ修正         | `fix(api): nullエラーを修正`     |
| `docs`     | ドキュメント     | `docs: READMEを更新`             |
| `style`    | コード整形       | `style: インデントを修正`        |
| `refactor` | リファクタリング | `refactor(db): クエリを最適化`   |
| `perf`     | パフォーマンス   | `perf: 画像読込を高速化`         |
| `test`     | テスト           | `test: ユニットテストを追加`     |
| `build`    | ビルド           | `build: webpack設定を更新`       |
| `ci`       | CI/CD            | `ci: GitHub Actionsを追加`       |
| `chore`    | その他           | `chore: 依存関係を更新`          |

### 形式

```
type(scope): subject

例:
feat(user): プロフィール編集機能を追加
fix(api): レスポンスのタイムアウト処理を修正
docs: インストール手順を追加
```

---

## ⌨️ czg キーバインド

### 基本操作

| キー      | 動作                     |
| --------- | ------------------------ |
| `↑` / `↓` | 項目選択                 |
| `Enter`   | 確定                     |
| `Ctrl+C`  | キャンセル（中断）       |
| `Tab`     | 補完（該当する場合）     |
| `Space`   | チェックボックスのトグル |

### 注意事項

- **戻る機能はありません** - 間違えた場合は`Ctrl+C`で中断して最初からやり直してください
- 各質問は順番に進み、前の項目には戻れません
- やり直したい場合は最初からやり直す方が確実です

---

## 🛠️ トラブルシューティング

### よくあるエラー

| エラー                      | 原因                | 解決方法                      |
| --------------------------- | ------------------- | ----------------------------- |
| `GEMINI_API_KEY is not set` | API未設定           | `export GEMINI_API_KEY="..."` |
| `command not found: jq`     | jq未インストール    | `brew install jq`             |
| `command not found: czg`    | czg未インストール   | `npm install -g czg`          |
| `No changes detected`       | 変更なし/未ステージ | `git add .` を実行            |
| `API Error: 400`            | 無効なAPIキー       | キーを確認して再設定          |
| `API Error: 429`            | レート制限          | 少し待ってから再試行          |

### デバッグコマンド

```bash
# 環境確認
echo $GEMINI_API_KEY        # APIキー確認
echo $GEMINI_MODEL          # モデル確認
which czg jq curl node      # コマンド確認

# セットアップ再実行
bash ~/.config/czg/setup.sh

# メッセージ生成テスト
cd /path/to/git/repo
git add .
bash ~/.config/czg/gemini-commit.sh
```

---

## 📁 ファイル一覧

```
~/.config/czg/
├── gemini-commit.sh          # AIメッセージ生成
├── czg-ai                    # メインコマンド
├── ai-commit.js              # czg統合用
├── .czrc                     # czg設定
├── setup.sh                  # セットアップ
├── README.md                 # 詳細ドキュメント
├── QUICKSTART.md             # クイックスタート
├── ARCHITECTURE.md           # システム構造
├── CHEATSHEET.md             # このファイル
└── fish-config-example.fish  # Fish設定例
```

---

## 🔗 便利なリンク

- **Gemini API Key**: https://aistudio.google.com/app/apikey
- **czg Documentation**: https://cz-git.qbb.sh/cli/
- **Conventional Commits**: https://www.conventionalcommits.org/
- **lazygit**: https://github.com/jesseduffield/lazygit

---

## 💡 Pro Tips

### 1. 部分的にコミット

```bash
# 変更を対話的に選択
git add -p

# AIでメッセージ生成
bash ~/.config/czg/czg-ai
```

### 2. プロンプトカスタマイズ

`~/.config/czg/gemini-commit.sh` の50行目付近を編集

### 3. czg設定カスタマイズ

```bash
# グローバル設定
~/.config/czg/.czrc

# プロジェクト固有設定
/path/to/project/.czrc
```

### 4. lazygitキーバインド変更

`~/.config/lazygit/config.yml`:

```yaml
customCommands:
  - key: "A" # 好きなキーに変更可能
    command: "bash ~/.config/czg/czg-ai"
```

---

## 📊 ワークフロー例

### シンプル

```bash
git add .
gai                    # エイリアス使用
# → 1を選択してコミット
```

### 編集が必要な場合

```bash
git add .
gai
# → 2を選択
# → czgで編集
# → Enterでコミット
```

### メッセージだけ確認

```bash
git add .
gaimsg                 # 生成のみ
# → メッセージをコピー
git commit -m "コピーしたメッセージ"
```

---

## 🎯 次のステップ

- [ ] APIキーを設定
- [ ] `bash ~/.config/czg/setup.sh` 実行
- [ ] エイリアスを設定
- [ ] lazygitで `A` キーを試す
- [ ] プロンプトをカスタマイズ

---

**Quick Help**: `cat ~/.config/czg/README.md` で詳細を表示
