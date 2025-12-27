alias g='git'

alias k='kubecolor'
alias kx='kubectx'

# Terraform
## Common
TF_ARCH="$(tr '[A-Z]' '[a-z]' <<<$(uname)_$(arch))"
alias tf='terraform fmt -recursive'
alias tfc='terraform fmt -check -recursive'
alias tv='terraform validate'
alias tt='terraform test'
alias ttv='terraform test -verbose'
alias tpl='terraform providers lock -platform=darwin_amd64 -platform=darwin_arm64 -platform=linux_amd64 -platform=linux_arm64 -platform=windows_amd64'
alias tpi='terraform providers mirror -platform="$TF_ARCH" ${HOME}/.terraform.d/plugins'
alias tdm='terraform-docs markdown --output-file=README.md .'
## Terraform without tfvars
alias ti='terraform init -reconfigure'
alias tp='terraform plan'
alias ta='terraform apply'
alias tc='terraform console'
## Terraform with tfvars
alias tvi='terraform init -reconfigure -backend-config="${ENV}/backend.tfvars"'
alias tvp='terraform plan -var-file="${ENV}/terraform.tfvars"'
alias tva='terraform apply -var-file="${ENV}/terraform.tfvars"'
alias tvc='terraform console -var-file="${ENV}/terraform.tfvars"'

alias say='say -v Samantha'
