# Github Action for Kubernetes CLI

This action provides `kubectl` for Github Actions.

## Usage

`.github/workflows/push.yml`

```yaml
on: push
name: deploy
jobs:
  deploy:
    name: deploy to cluster
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: deploy to cluster
      uses: steebchen/kubectl@master
      with:
        config: ${{ secrets.KUBE_CONFIG_DATA }}
        version: v1.21.0
        command: set image --record deployment/my-app container=${{ github.repository }}:${{ github.sha }}
    - name: verify deployment
      uses: steebchen/kubectl@master
      with:
        config: ${{ secrets.KUBE_CONFIG_DATA }}
        version: v1.21.0
        command: rollout status deployment/my-app
```

## Inputs

`config` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```

`version` – **required**: The kubectl version with a 'v' prefix, e.g. `v1.21.0`

**Note**: Do not use kubectl config view as this will hide the certificate-authority-data.
