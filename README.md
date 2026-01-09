# dotfiles

My personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Managed Tools

| Tool | Description |
|------|-------------|
| **Ghostty** | GPU-accelerated terminal emulator |
| **tmux** | Terminal multiplexer with plugins |
| **yazi** | Blazing fast terminal file manager |
| **zsh** | Z shell configuration |
| **Claude Code** | Anthropic's CLI for Claude |

## Quick Start

### New Machine Setup

```bash
# Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply hamusack
```

Or step by step:

```bash
# 1. Install chezmoi
brew install chezmoi

# 2. Initialize with this repo
chezmoi init hamusack

# 3. Set required environment variables (see below)
# 4. Apply dotfiles
chezmoi apply
```

## Required Environment Variables

Before running `chezmoi apply`, set these environment variables in your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
# GitHub Personal Access Token (for GitHub Copilot MCP)
export GITHUB_PAT="your_github_pat_here"

# Slack Bot Token (for Slack MCP)
export SLACK_BOT_TOKEN="xoxb-your-token-here"
export SLACK_TEAM_ID="your-team-id"
```

### How to get tokens

#### GitHub PAT
1. Go to [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
2. Generate a new token with required scopes
3. Copy and set as `GITHUB_PAT`

#### Slack Bot Token
1. Go to [Slack API Apps](https://api.slack.com/apps)
2. Create or select your app
3. Navigate to "OAuth & Permissions"
4. Copy the "Bot User OAuth Token" (`xoxb-...`)
5. Set as `SLACK_BOT_TOKEN`
6. Team ID can be found in your Slack workspace URL

## File Structure

```
~/.config/
├── ghostty/
│   └── config           # Ghostty terminal settings
└── yazi/
    ├── theme.toml       # Yazi theme (catppuccin-mocha)
    └── flavors/         # Yazi color themes

~/.claude/
├── CLAUDE.md            # Claude Code instructions
├── settings.json        # Claude Code settings (templated)
├── settings.local.json  # Permission settings
├── hooks/               # Session hooks
├── commands/            # Custom commands
└── agents/              # Custom agents

~/.tmux.conf             # tmux configuration
~/.zshrc                 # Zsh configuration
```

## Post-Installation

### tmux Plugins

After applying dotfiles, install tmux plugins:

```bash
# Start tmux
tmux

# Install plugins (inside tmux)
# Press: prefix + I (Ctrl+b, then Shift+I)
```

### Ghostty

Reload config after changes:
- Press `Cmd + Shift + R`

## Updating

```bash
# Pull latest changes
chezmoi update

# Or manually
chezmoi git pull
chezmoi apply
```

## Adding New Dotfiles

```bash
# Add a file to chezmoi management
chezmoi add ~/.config/some/config

# Edit managed file
chezmoi edit ~/.config/some/config

# Apply changes
chezmoi apply
```

## License

MIT
