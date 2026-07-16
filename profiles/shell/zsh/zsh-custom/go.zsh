if which go &> /dev/null; then
    export GOPATH="${HOME}/go"
    path=("${GOPATH}/bin" $path)
fi
