# KubeOne

Using version `KubeOne` version `ccc`

## Installing `KubeOne`

* `Kubeone` can be installed on linux and MacOS, but not windows.
* shell :

```bash

# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
#
export KUBEONE_VERSION=0.11.0
# ---
# can be :
# => 'darwin' (mac os)
# => linux (for any GNU/Linux distrib.)
# Kubeone does not support Windows
# 
export KUBEONE_OS=linux

curl -LO https://github.com/kubermatic/kubeone/releases/download/v<version>/kubeone_<version>_<operating_system>_amd64.zip
