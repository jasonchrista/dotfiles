# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# PATH
typeset -U path PATH
path=(
  "$HOME/bin"
  "$HOME/.cargo/bin"
  /opt/homebrew/opt/openssl@3/bin
  /opt/homebrew/opt/mysql-client/bin
  $path
)
export PATH

# Environment
export RUST_BACKTRACE=1

if command -v brew >/dev/null 2>&1; then
  mysql_client_pkgconfig="$(brew --prefix mysql-client)/lib/pkgconfig"
  case ":${PKG_CONFIG_PATH:-}:" in
    *":${mysql_client_pkgconfig}:"*) ;;
    *) export PKG_CONFIG_PATH="${mysql_client_pkgconfig}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" ;;
  esac
  unset mysql_client_pkgconfig
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(zsh-autosuggestions)

if [[ -n "${HOMEBREW_PREFIX:-}" && -d "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]]; then
  FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi

source "$ZSH/oh-my-zsh.sh"

# Aliases
alias cat=bat
alias dig=dog
alias du="erd -H --disk-usage block --icons --layout flat --no-ignore --no-git --hidden --level 1 --dir-order first --sort rsize"
alias df=duf
alias help=tldr
alias ls="lsd --group-dirs first"
alias ping="prettyping --nolegend"
alias top=bpytop

# Optional integrations
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"
[[ -f "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"
[[ -f "$HOME/.vite-plus/env" ]] && source "$HOME/.vite-plus/env"
