ks() {
  kubectl $@ --namespace=kube-system
}

kn() {
  kubectl $@ --namespace=${KUBE_NS:-default}
}

kns() {
  export KUBE_NS=$@
}

kc() {
  if [ -z "${1}" ]; then
    echo "Current context: $(kubectl config current-context)"
    echo "Available Contexts:"
    kubectl config get-contexts -o name
  else
    kubectl config use-context ${1}
  fi
}

mysql_db() {
  kubectl run mysql --rm -ti --generator=run-pod/v1 --image=mysql:5.6 --command -- bash
}

kcdel() {
  if (( $# != 1 )) || [[ -z "$1" ]]; then
    print -u2 -- 'Usage: kcdel <context>'
    return 2
  fi

  local context_name="$1" kubeconfig context cluster_name user_name
  local cluster_in_use user_in_use
  kubeconfig=$(kubectl config view -o json) || return
  context=$(jq -ce --arg name "$context_name" \
    'first(.contexts[]? | select(.name == $name)) // empty' <<< "$kubeconfig") || {
    print -u2 -- "Context not found: $context_name"
    return 1
  }
  cluster_name=$(jq -r '.context.cluster // empty' <<< "$context") || return
  user_name=$(jq -r '.context.user // empty' <<< "$context") || return

  kubectl config delete-context -- "$context_name" || return
  # Re-read all contexts after deletion, including merged KUBECONFIG files.
  kubeconfig=$(kubectl config view -o json) || return
  cluster_in_use=$(jq -r --arg name "$cluster_name" \
    'any(.contexts[]?; .context.cluster == $name)' <<< "$kubeconfig") || return
  user_in_use=$(jq -r --arg name "$user_name" \
    'any(.contexts[]?; .context.user == $name)' <<< "$kubeconfig") || return

  if [[ -n "$cluster_name" && "$cluster_in_use" == false ]]; then
    kubectl config delete-cluster -- "$cluster_name" || return
  fi
  if [[ -n "$user_name" && "$user_in_use" == false ]]; then
    kubectl config delete-user -- "$user_name" || return
  fi
  return 0
}
