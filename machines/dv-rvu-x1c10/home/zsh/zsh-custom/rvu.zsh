# Load u ZSH Shell completion script
if which u &> /dev/null; then eval "$(u --completion-script-zsh)"; fi

knek1() {
  kubectl $@ --namespace=${KUBE_NS:-default} --context "eks-01"
}

knek2() {
  kubectl $@ --namespace=${KUBE_NS:-default} --context "eks-02"
}
