# Github Action for Kubernetes CLI

This action provides `kubectl` for Github Actions.

## Usage

```hcl
workflow "build and deploy" {
  on = "push"
  resolves = ["verify deployment"]
}

action "deploy to cluster" {
  needs = ["todo: build and push containers"]
  uses = "steebchen/kubectl@master"
  args = "set image --record deployment/my-app container=$GITHUB_REPOSITORY:$GITHUB_SHA"
  secrets = ["KUBE_CONFIG_DATA"]
}

action "verify deployment" {
  needs = "deploy to cluster"
  uses = "steebchen/kubectl@master"
  args = ["rollout status deployment/aws-example-octodex"]
  secrets = ["KUBE_CONFIG_DATA"]
}
```

## Secrets

`KUBE_CONFIG_DATA` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```

**Note**: Do not use kubectl config view as this will hide the certificate-authority-data.
