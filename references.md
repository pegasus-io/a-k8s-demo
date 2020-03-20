# Références Utilisées



# Cluster K8S

Pour monter cette démo, j'ai comparé les caractéristiques de mon prototype, à celles discutées dans les artyicles suivants :

* https://medium.com/@saidur2/setup-a-kubernetes-cluster-in-aws-under-20-minutes-ecab147c4d89 : beaucoup trop ancien, ne serait-ce que pour la partie `Kubernetes`, je comparerai la partie Architecture globale.
* https://kubernetes.io/docs/setup/production-environment/turnkey/aws/ : officviel et actuel.
* https://medium.com/containermind/how-to-create-a-kubernetes-cluster-on-aws-in-few-minutes-89dda10354f4 :  me semble un bon compromis, quant aux dates de `2018`.

### Le plus direct

Et permet au passage d'avoir une recette prête pour l'autoscale `AWS`

* https://dzone.com/articles/running-ha-kubernetes-clusters-on-aws-using-kubeon :  un exemple de setup k8S aws basé sur `kubeone`. Oui, c'est celui là qu'il faut faire.

* dans le conteneur `kubeone` :

```bash

export WORKDIR=$(pwd)
# amd64 only supported for the moment.
export KBONE_CPU_ARCH=amd64
# 'linux' or 'darwin', windows is not supported
export KBONE_OS=linux
export KBONE_VERSION=0.11.0
export KBONE_PKG_DWNLD_URI=https://github.com/kubermatic/kubeone/releases/download/v${KBONE_VERSION}/kubeone_${KBONE_VERSION}_${KBONE_OS}_${KBONE_CPU_ARCH}.zip
export KBONE_CHKSUMS_DWNLD_URI=https://github.com/kubermatic/kubeone/releases/download/v${KBONE_VERSION}/kubeone_${KBONE_VERSION}_checksums.txt

# etc.. tel que décrit dans https://dzone.com/articles/running-ha-kubernetes-clusters-on-aws-using-kubeon
```


# Déploiement de l'applciation dans le Cluster : `Gitlab CI + Helm`

Implémenter la solution suivante : 

https://about.gitlab.com/blog/2017/09/21/how-to-create-ci-cd-pipeline-with-autodeploy-to-kubernetes-using-gitlab-and-helm/
