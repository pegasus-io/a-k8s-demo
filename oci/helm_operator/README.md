# Helm image defintion

## Orchestration

* The helm operator needs the `Kubectl` config.
* the kubeone operator sets that config on the remote host.
* so we need to have finished the `kubeone` operatins, before we run the helm operator.
* beesecrets named volume will allow retrieving kubeconfig, which is a secret.

## Very Worth learning

* Those signatures for the social helm :

```bash
helm package --sign ...

# Very simple :  Helm works based on at least on git repo. To Collaborate. IAAC

```
