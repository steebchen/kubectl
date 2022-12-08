#!/bin/sh

set -e

version="$1"
config="$2"
command="$3"
binaries_url="$4"

if [ -z "$binaries_url" ]; then
  if [ "$version" = "latest" ]; then
    version=$(curl -Ls https://dl.k8s.io/release/stable.txt)
  fi

  echo "using kubectl@$version"

  curl -sLO "https://dl.k8s.io/release/$version/bin/linux/amd64/kubectl" -o kubectl
else
  echo "downloading kubectl binaries from $binaries_url"
  curl -sLO $binaries_url -o kubectl
fi

chmod +x kubectl
mv kubectl /usr/local/bin

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$config" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config

sh -c "kubectl $command"
