# dotfiles

[chezmoi](https://www.chezmoi.io/) で管理している個人用の dotfiles です。

## 管理しているツール

| ツール | 説明 |
|--------|------|
| **Ghostty** | GPU アクセラレーション対応ターミナル |
| **tmux** | ターミナルマルチプレクサ（プラグイン込み） |
| **yazi** | 爆速ターミナルファイルマネージャー |
| **zsh** | Z シェル設定 |
| **Claude Code** | Anthropic の Claude CLI ツール |

## クイックスタート

### 新しいマシンでのセットアップ

```bash
# chezmoi をインストールして dotfiles を適用
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply hamusack
```

または手動で：

```bash
# 1. chezmoi をインストール
brew install chezmoi

# 2. このリポジトリで初期化
chezmoi init hamusack

# 3. 環境変数を設定（下記参照）

# 4. dotfiles を適用
chezmoi apply
```

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
~/.config/
├── ghostty/
│   └── config           # Ghostty ターミナル設定
└── yazi/
    ├── theme.toml       # Yazi テーマ（catppuccin-mocha）
    └── flavors/         # Yazi カラーテーマ

~/.claude/
├── CLAUDE.md            # Claude Code の指示書
├── settings.json        # Claude Code 設定（テンプレート）
├── settings.local.json  # パーミッション設定
├── hooks/               # セッションフック
├── commands/            # カスタムコマンド
└── agents/              # カスタムエージェント

~/.tmux.conf             # tmux 設定
~/.zshrc                 # Zsh 設定
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

```bash
# 最新の変更を取得して適用
chezmoi update

# または手動で
chezmoi git pull
chezmoi apply
```

## 新しい dotfile を追加する

```bash
# ファイルを chezmoi 管理下に追加
chezmoi add ~/.config/some/config

# 管理下のファイルを編集
chezmoi edit ~/.config/some/config

# 変更を適用
chezmoi apply
```

## ライセンス

MIT
