# システムアーキテクチャ

Gemini AIコミットメッセージ生成システムの構造と動作フローを説明します。

## 📐 システム構成図

```
┌─────────────────────────────────────────────────────────────────┐
│                          lazygit UI                              │
│                                                                   │
│  ┌───────────────┐  ┌───────────────┐  ┌──────────────────┐    │
│  │  Press 'A'    │  │  Press 'Z'    │  │  Regular Commit  │    │
│  │  (AI Commit)  │  │  (czg)        │  │                  │    │
│  └───────┬───────┘  └───────┬───────┘  └──────────────────┘    │
└──────────┼──────────────────┼──────────────────────────────────┘
           │                  │
           │                  │
           ▼                  ▼
    ┌──────────────┐   ┌──────────────┐
    │   czg-ai     │   │     czg      │
    │   (bash)     │   │   (Node.js)  │
    └──────┬───────┘   └──────┬───────┘
           │                  │
           │                  │ (when user types :ai)
           │                  │
           ▼                  ▼
    ┌─────────────────────────────────┐
    │    gemini-commit.sh             │
    │    (Bash Script)                │
    │                                  │
    │  1. Get git diff                │
    │  2. Build prompt                │
    │  3. Call Gemini API             │
    │  4. Parse response              │
    │  5. Return commit message       │
    └────────────┬────────────────────┘
                 │
                 │ HTTP POST
                 ▼
    ┌─────────────────────────────────┐
    │      Gemini API                  │
    │  (Google Cloud)                  │
    │                                  │
    │  - Model: gemini-2.5-flash　　   │
    │  - Analyzes diff                │
    │  - Generates commit message     │
    └──────────────────────────────────┘
```

## 🔄 動作フロー

### フロー1: lazygitから 'A' キーでAIコミット

```
1. User: lazygitで 'A' キーを押す
   ↓
2. lazygit: czg-ai スクリプトを実行
   ↓
3. czg-ai:
   - git diff --cached を取得
   - gemini-commit.sh を呼び出し
   ↓
4. gemini-commit.sh:
   - diffをJSON形式にエスケープ
   - プロンプトを構築
   - Gemini APIにPOSTリクエスト
   - レスポンスをパース
   - コミットメッセージを返却
   ↓
5. czg-ai:
   - 生成されたメッセージを表示
   - ユーザーに選択肢を提示:
     [1] そのままコミット
     [2] czgで編集
     [3] キャンセル
   ↓
6. User: オプションを選択
   ↓
7. 選択に応じて:
   [1] → git commit -m "message"
   [2] → czg起動（メッセージ付き）
   [3] → 終了
```

### フロー2: czgから ':ai' でAI生成

```
1. User: lazygitで 'Z' キーを押す（または czg コマンド実行）
   ↓
2. czg: インタラクティブプロンプトを開始
   ↓
3. User: subject入力欄で ':ai' と入力
   ↓
4. czg: alias設定に基づき ai-commit.js を実行
   ↓
5. ai-commit.js: gemini-commit.sh をラップして呼び出し
   ↓
6. gemini-commit.sh:
   - AIでメッセージ生成（フロー1の4と同じ）
   - メッセージを返却
   ↓
7. czg: 生成されたメッセージをsubjectフィールドに挿入
   ↓
8. User: そのまま確定 or 編集後に確定
```

## 📂 ファイル構成と役割

```
~/.config/czg/
│
├── gemini-commit.sh          # コアスクリプト（AI生成ロジック）
│   ├─ 役割: Git diffを取得し、Gemini APIで解析
│   ├─ 入力: git diff --cached
│   ├─ 出力: コミットメッセージ（文字列）
│   └─ 依存: curl, jq, GEMINI_API_KEY
│
├── czg-ai                     # メインコマンド（ユーザーインターフェース）
│   ├─ 役割: AIコミットの対話的インターフェース
│   ├─ 機能:
│   │   - gemini-commit.shを呼び出し
│   │   - 生成されたメッセージを表示
│   │   - ユーザーに選択肢を提示
│   │   - 選択に応じて git commit または czg を実行
│   └─ 依存: gemini-commit.sh
│
├── ai-commit.js              # Node.jsラッパー（czg統合用）
│   ├─ 役割: czgの:aiエイリアスから呼ばれる
│   ├─ 機能: gemini-commit.shを実行し、結果をczgに返す
│   └─ 依存: Node.js, gemini-commit.sh
│
├── .czrc                      # czg設定ファイル
│   ├─ 役割: czgの動作をカスタマイズ
│   ├─ 設定内容:
│   │   - 日本語メッセージ
│   │   - Conventional Commits types
│   │   - :ai エイリアス設定
│   └─ 使用: czg起動時に自動読み込み
│
├── setup.sh                   # セットアップスクリプト
│   ├─ 役割: 初回セットアップとテスト
│   ├─ 機能:
│   │   - 依存関係チェック
│   │   - API接続テスト
│   │   - パーミッション設定
│   └─ 実行: bash ~/.config/czg/setup.sh
│
├── README.md                  # 詳細ドキュメント
├── QUICKSTART.md             # クイックスタートガイド
├── ARCHITECTURE.md           # このファイル
└── fish-config-example.fish  # Fish Shell設定例
```

## 🔌 API通信の詳細

### リクエスト構造

```json
{
  "contents": [{
    "parts": [{
      "text": "プロンプト + git diff"
    }]
  }],
  "generationConfig": {
    "temperature": 0.3,      // 創造性を抑えて一貫性重視
    "maxOutputTokens": 200,  // 短いメッセージ生成
    "topP": 0.8,
    "topK": 10
  }
}
```

### エンドポイント

```
POST https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={API_KEY}
```

### レスポンス構造

```json
{
  "candidates": [{
    "content": {
      "parts": [{
        "text": "feat(auth): ユーザー認証機能を追加"
      }]
    }
  }]
}
```

## 🔐 セキュリティ考慮事項

### API キーの管理

```
✓ 良い例:
  - 環境変数に設定
  - シェル設定ファイルに記載（ローカル）
  - .gitignoreで除外

✗ 悪い例:
  - スクリプトにハードコード
  - リポジトリにコミット
  - 公開される場所に記載
```

### データの取り扱い

- **送信データ**: git diffの内容
  - コミット前の変更内容がGoogleに送信される
  - 機密情報を含むコードの場合は注意が必要

- **対策**:
  - プライベートな情報を含むリポジトリでは使用を控える
  - または、手動でメッセージを編集するオプションを選択

## ⚙️ カスタマイズポイント

### 1. プロンプトの変更

`gemini-commit.sh` の `generate_commit_message()` 関数内：

```bash
local prompt="あなたは経験豊富なソフトウェアエンジニアです..."
```

### 2. モデルの変更

環境変数で設定：

```bash
export GEMINI_MODEL="gemini-1.5-pro"
```

### 3. czgの動作変更

`.czrc` ファイルを編集：

```json
{
  "useEmoji": true,
  "types": [...],
  "scopes": [...]
}
```

### 4. lazygitのキーバインド変更

`~/.config/lazygit/config.yml`:

```yaml
customCommands:
  - key: "A"  # ← 好きなキーに変更可能
    context: "files"
    command: "bash ~/.config/czg/czg-ai"
```

## 🚀 パフォーマンス最適化

### レスポンス時間の要因

1. **ネットワーク遅延**: 100-500ms
2. **API処理時間**: 500-2000ms
3. **diff サイズ**: 大きいほど遅い

### 最適化のヒント

```bash
# 高速モデルを使用（デフォルト）
export GEMINI_MODEL="gemini-2.0-flash-exp"

# diff サイズを制限（大規模変更の場合）
git diff --cached --stat  # 変更を確認
git add -p               # 部分的にステージング
```

## 🧪 テストとデバッグ

### デバッグモード

スクリプトにデバッグ出力を追加：

```bash
# gemini-commit.sh の先頭に追加
set -x  # コマンドをトレース

# または、特定の箇所に
echo "Debug: diff length = ${#diff}" >&2
echo "Debug: API response = $response" >&2
```

### テストコマンド

```bash
# 1. API接続テスト
bash ~/.config/czg/setup.sh

# 2. メッセージ生成のみテスト
cd /path/to/git/repo
git add .
bash ~/.config/czg/gemini-commit.sh

# 3. 完全なフローテスト
bash ~/.config/czg/czg-ai
```

## 📊 制限事項

### Gemini API

- **無料枠**: 1分あたり15リクエスト
- **最大トークン**: 入力32K、出力8K
- **レート制限**: 超過時は429エラー

### git diff サイズ

- **推奨**: 10,000文字以内
- **最大**: 100,000文字（APIの制限により）

### 対応するシェル

- ✅ Bash
- ✅ Zsh
- ✅ Fish (エイリアス設定が若干異なる)
- ❓ PowerShell (未テスト)

## 🔄 アップデートとメンテナンス

### バージョン管理

現在のバージョン: `1.0.0`

### 将来の拡張案

- [ ] 複数のAIプロバイダー対応（OpenAI、Claude等）
- [ ] コミットメッセージのテンプレート機能
- [ ] プロジェクト固有の設定
- [ ] コミット履歴からの学習
- [ ] GitHub Issues/PRとの連携

## 📞 サポート

問題が発生した場合：

1. `bash ~/.config/czg/setup.sh` を実行してシステムをチェック
2. `README.md` のトラブルシューティングセクションを確認
3. API キーとネットワーク接続を確認

---

**Last Updated**: 2024-10-24
**Version**: 1.0.0
