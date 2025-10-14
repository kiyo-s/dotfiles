# shellcheck disable=SC2148
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ${HOME}/.p10k.zsh ]] || source "${HOME}/.p10k.zsh"
autoload -Uz promptinit
promptinit
prompt powerlevel10k

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    autoload -Uz compinit && compinit
    autoload bashcompinit && bashcompinit
fi

# tools version management
## mise
eval "$(mise activate zsh)"

# include all .zsh files in ~/.zsh
if [[ -d "${HOME}/.zsh" ]]; then
    for file in "${HOME}/.zsh"/*.zsh; do
        source "$file"
    done
fi
