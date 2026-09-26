# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# PATH
typeset -U path PATH fpath FPATH
path=(
  "$HOME/.local/bin"
  "${HOMEBREW_PREFIX}/opt/mysql-client/bin"
  $path
)
export PATH

# Environment
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1
[[ -r "$HOME/.config/shell/secrets.zsh" ]] && source "$HOME/.config/shell/secrets.zsh"

mysql_client_pkgconfig="${HOMEBREW_PREFIX:-}/opt/mysql-client/lib/pkgconfig"
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "$mysql_client_pkgconfig" ]]; then
  case ":${PKG_CONFIG_PATH:-}:" in
    *":${mysql_client_pkgconfig}:"*) ;;
    *) export PKG_CONFIG_PATH="${mysql_client_pkgconfig}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" ;;
  esac
fi
unset mysql_client_pkgconfig

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(zsh-autosuggestions)

source "$ZSH/oh-my-zsh.sh"

# Aliases
alias cat=bat
alias dig=dog
alias du="erd -H --unit si --disk-usage physical --icons --layout flat --no-ignore --no-git --hidden --level 1 --dir-order first --sort rsize"
alias df=duf
alias help=tldr
alias ls="lsd --group-dirs first"
alias ping="prettyping --nolegend"
alias top=btm

# Commands
unalias upall 2>/dev/null || :
[[ -r "$HOME/.config/zsh/upall.zsh" ]] && source "$HOME/.config/zsh/upall.zsh"

# Optional integrations
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi
[[ -f "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"
[[ -f "$HOME/.vite-plus/env" ]] && source "$HOME/.vite-plus/env"
