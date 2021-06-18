# GitHub Action for Kubernetes CLI

This action provides `kubectl` for GitHub Actions.

## Upgrading from v1 to v2

If you upgrade from v1 to v2, note that you need to specify new variables via `with`, namely `version`, `config`, and `command`. See below for an example.

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
      uses: steebchen/kubectl@v2.0.0
      with: # defaults to latest kubectl binary version
        config: ${{ secrets.KUBE_CONFIG_DATA }}
        command: set image --record deployment/my-app container=${{ github.repository }}:${{ github.sha }}
    - name: verify deployment
      uses: steebchen/kubectl@v2.0.0
      with:
        config: ${{ secrets.KUBE_CONFIG_DATA }}
        version: v1.21.0 # specify kubectl binary version explicitly
        command: rollout status deployment/my-app
```

## Arguments

`command` – **required**: The command you want to run, without `kubectl`, e.g. `get pods`

`config` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```

`version`: The kubectl version with a 'v' prefix, e.g. `v1.21.0`. It defaults to the latest kubectl binary version available.

**Note**: Do not use kubectl config view as this will hide the certificate-authority-data.
