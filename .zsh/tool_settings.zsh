if [[ ! -z $commands[mise] ]]; then
    source <(mise complete --shell zsh)
fi

if [[ -z $commands[awscli] ]]; then
    complete -C $(which aws_completer) aws
fi

if [[ -z $commands[go] ]]; then
    export GODEBUG="asyncpreemptoff=1"
fi

if [[ ! -z $commands[helm] ]]; then
    source <(helm completion zsh)
fi

if [[ ! -z $commands[helmfile] ]]; then
    source <(helmfile completion zsh)
fi

if [[ ! -z $commands[kubectl] ]]; then
    source <(kubectl completion zsh)
fi

if [[ ! -z $commands[kubecolor] ]]; then
    compdef kubecolor=kubectl
    export KUBECOLOR_PRESET="protanopia-dark"
    export KUBECOLOR_OBJ_FRESH="24h"
fi

if [[ ! -z $commands[terraform] ]]; then
    complete -C $(which terraform) terraform
    export TF_CLI_ARGS_plan="--parallelism=100"
    export TF_CLI_ARGS_apply="--parallelism=100"
fi

if [[ ! -z $commands[terraform-docs] ]]; then
    source <(terraform-docs completion zsh)
fi

if [[ ! -z $commands[uv] ]]; then
    source <(uv generate-shell-completion zsh)
fi
