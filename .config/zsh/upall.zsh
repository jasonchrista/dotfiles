upall() {
  setopt local_options no_err_exit no_err_return
  local -a failures
  local exit_code

  print -P "\n%F{cyan}==> uv%f"
  uv self update
  exit_code=$?
  (( exit_code == 0 )) || failures+=("uv ($exit_code)")

  print -P "\n%F{cyan}==> Vite+%f"
  vp upgrade
  exit_code=$?
  (( exit_code == 0 )) || failures+=("Vite+ ($exit_code)")

  print -P "\n%F{cyan}==> Oh My Zsh%f"
  ZSH="$ZSH" command zsh -f "$ZSH/tools/upgrade.sh" -v minimal -c 0
  exit_code=$?
  if (( exit_code == 0 )); then
    zmodload zsh/datetime
    print -r -- "LAST_EPOCH=$(( EPOCHSECONDS / 60 / 60 / 24 ))" >! "${ZSH_CACHE_DIR}/.zsh-update"
    exit_code=$?
    if (( exit_code == 0 )); then
      command rm -rf "$ZSH/log/update.lock"
      exit_code=$?
    fi
  fi
  (( exit_code == 0 )) || failures+=("Oh My Zsh ($exit_code)")

  print -P "\n%F{cyan}==> Homebrew formulas%f"
  brew upgrade --formula --no-ask
  exit_code=$?
  (( exit_code == 0 )) || failures+=("Homebrew formulas ($exit_code)")

  print -P "\n%F{cyan}==> Homebrew cleanup%f"
  brew cleanup
  exit_code=$?
  (( exit_code == 0 )) || failures+=("Homebrew cleanup ($exit_code)")

  print -P "\n%F{cyan}==> tldr cache%f"
  tldr --update
  exit_code=$?
  (( exit_code == 0 )) || failures+=("tldr cache ($exit_code)")

  if (( ${#failures[@]} > 0 )); then
    print -u2 -P "\n%F{red}Completed with failures:%f"
    printf '  - %s\n' "${failures[@]}" >&2
    return 1
  fi

  print -P "\n%F{green}All updates completed.%f"
}
