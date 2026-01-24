# dotfiles

[chezmoi](https://www.chezmoi.io/) で管理している個人用の dotfiles です。

## 特徴

- **ワンコマンドセットアップ** - 新しいマシンでも1コマンドで環境構築
- **Brewfile 管理** - ソフトウェアも含めて完全に再現可能
- **テンプレート機能** - ユーザー名やパスを動的に生成

## 管理しているツール

| ツール | 説明 |
|--------|------|
| **Ghostty** | GPU アクセラレーション対応ターミナル |
| **tmux** | ターミナルマルチプレクサ（プラグイン込み） |
| **yazi** | 爆速ターミナルファイルマネージャー |
| **zsh** | Z シェル設定（Zinit プラグイン管理） |
| **Claude Code** | Anthropic の Claude CLI ツール |
| **Neovim** | モダンな Vim |

## クイックスタート

### 新しいマシンでのセットアップ（推奨）

```bash
# これだけで Homebrew、全パッケージ、dotfiles が自動インストールされる！
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply hamusack
```

初回実行時に以下が自動でインストールされます：
- Homebrew（未インストールの場合）
- Brewfile に記載された全パッケージ
- Zinit（Zsh プラグインマネージャー）
- TPM（tmux プラグインマネージャー）

### 手動セットアップ

```bash
# 1. chezmoi をインストール
brew install chezmoi

# 2. このリポジトリで初期化
chezmoi init hamusack

# 3. 差分を確認
chezmoi diff

# 4. dotfiles を適用
chezmoi apply
```

### 既に chezmoi を使っている場合（再セットアップ）

一度 `chezmoi apply` を実行すると、セットアップスクリプトは「実行済み」として記録されます。
再度セットアップスクリプトを実行したい場合：

```bash
# 1. 最新の dotfiles を取得
chezmoi update

# 2. スクリプトの実行状態をリセット
chezmoi state delete-bucket --bucket=scriptState

# 3. 再度適用（セットアップスクリプトが実行される）
chezmoi apply
```

### セットアップで何が起こるか

`chezmoi apply` 実行時に `run_once_before_executable_install-packages.sh` が自動実行され：

1. **Homebrew チェック** - 未インストールなら自動インストール
2. **Brewfile インストール** - `brew bundle` で全パッケージをインストール
3. **Zinit インストール** - Zsh プラグインマネージャー
4. **TPM インストール** - tmux プラグインマネージャー

完了後、ターミナルを再起動するか `source ~/.zshrc` を実行してください。

## 必要な環境変数

`chezmoi apply` を実行する前に、シェルプロファイル（`~/.zshrc` または `~/.bashrc`）に以下の環境変数を設定してください：

```bash
# GitHub Personal Access Token（GitHub Copilot MCP 用）
export GITHUB_PAT="your_github_pat_here"

# Slack Bot Token（Slack MCP 用）
export SLACK_BOT_TOKEN="xoxb-your-token-here"
export SLACK_TEAM_ID="your-team-id"
```

### トークンの取得方法

#### GitHub PAT
1. [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens) にアクセス
2. 必要なスコープで新しいトークンを生成
3. コピーして `GITHUB_PAT` に設定

#### Slack Bot Token
1. [Slack API Apps](https://api.slack.com/apps) にアクセス
2. アプリを作成または選択
3. 「OAuth & Permissions」に移動
4. 「Bot User OAuth Token」（`xoxb-...`）をコピー
5. `SLACK_BOT_TOKEN` に設定
6. Team ID は Slack ワークスペースの URL から確認できます

## ファイル構成

```
dotfiles/
├── .chezmoi.toml.tmpl              # chezmoi 設定（テンプレート）
├── Brewfile                         # Homebrew パッケージ一覧
├── run_once_before_executable_install-packages.sh.tmpl  # 初回セットアップスクリプト
│
├── dot_zshrc.tmpl                   # Zsh 設定（テンプレート）
├── dot_tmux.conf                    # tmux 設定
│
├── dot_config/
│   ├── ghostty/
│   │   └── config                   # Ghostty ターミナル設定
│   └── yazi/
│       ├── theme.toml               # Yazi テーマ（catppuccin-mocha）
│       └── flavors/                 # Yazi カラーテーマ
│
└── dot_claude/
    ├── CLAUDE.md                    # Claude Code の指示書
    ├── settings.json.tmpl           # Claude Code 設定（テンプレート）
    ├── settings.local.json          # パーミッション設定
    ├── hooks/                       # セッションフック
    ├── commands/                    # カスタムコマンド
    └── agents/                      # カスタムエージェント
```

## インストール後の作業

### tmux プラグイン

dotfiles 適用後、tmux プラグインをインストール：

```bash
# tmux を起動
tmux

# プラグインをインストール（tmux 内で）
# prefix + I を押す（Ctrl+b → Shift+I）
```

### Ghostty

設定変更後のリロード：
- `Cmd + Shift + R` を押す

## 更新

### 現在のマシンから設定を更新

```bash
# ファイルを chezmoi 管理下に追加
chezmoi add ~/.config/some/config

# 管理下のファイルを編集
chezmoi edit ~/.config/some/config

# 変更を適用
chezmoi apply

# リポジトリにコミット
chezmoi git add .
chezmoi git commit -m "Update config"
chezmoi git push
```

### 別マシンで最新を取得

```bash
# 最新の変更を取得して適用
chezmoi update

# または手動で
chezmoi git pull
chezmoi apply
```

## Brewfile の更新

新しいパッケージをインストールした場合：

```bash
# 現在のパッケージ一覧を Brewfile に反映
brew bundle dump --file=$(chezmoi source-path)/Brewfile --force

# コミット
chezmoi git add .
chezmoi git commit -m "Update Brewfile"
chezmoi git push
```

## トラブルシューティング

### セットアップスクリプトが実行されない

スクリプトが「実行済み」として記録されている可能性があります：

```bash
# スクリプトの実行状態をリセット
chezmoi state delete-bucket --bucket=scriptState

# 再度適用
chezmoi apply
```

### Homebrew パッケージがインストールされない

手動で Brewfile からインストール：

```bash
brew bundle --file=$(chezmoi source-path)/Brewfile
```

### テンプレート変数が展開されない

```bash
# テンプレートの展開結果を確認
chezmoi execute-template < $(chezmoi source-path)/dot_zshrc.tmpl
```

### 差分を確認したい

```bash
# 全ファイルの差分を確認
chezmoi diff

# 特定ファイルの差分
chezmoi diff ~/.zshrc
```

### 適用前に dry-run

```bash
chezmoi apply --dry-run --verbose
```

### chezmoi の設定をリセットしたい

```bash
# 設定ファイルを再生成
chezmoi init hamusack

# 全状態をリセット（注意: 全てリセットされる）
chezmoi state reset
```

## ライセンス

MIT
