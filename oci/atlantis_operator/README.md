# Atlantis image defintion

Using version `Atlantis` version `x.y.z` : `March 2020`

The Git Repo in which the terraform Recipe and state is versioned, is https://github.com/pegasus-io/example-cresh-atlantic-infra

## Installing `Atlantis` in the base alpine image

* `Atlantis` can be installed on linux and MacOS, but not windows.
* I like bash, and installed it in my base alpine blend : `./install-atlantis.sh`


```bash

export EXPRESS_NODE_APPLICATION_DOCKER_ORG=pegasusio

docker build -t ${EXPRESS_NODE_APPLICATION_DOCKER_ORG}/atlantis-cresh:0.0.1 .


export ATLANTIS_GH_TOKEN=ea1beefea1beef42553Xf
export ATLANTIS_GH_USERNAME='Jean-Baptiste-Lasselle'
export ATLANTIS_URL="http://pegasusio.io"
export ATLANTIS_GH_WEBHOOK_SECRET=""
export ATLANTIS_REPO_WHITELIST="github.com;140.82.118.4"


# ----
# without webhook secret :
docker run --name jblatlantis -p 34141:4141 ${EXPRESS_NODE_APPLICATION_DOCKER_ORG}/atlantis-cresh:0.0.1 server --gh-user=${ATLANTIS_GH_USERNAME} --gh-token=${ATLANTIS_GH_TOKEN} --repo-whitelist=${ATLANTIS_REPO_WHITELIST} --atlantis-url=${ATLANTIS_URL}

# ----
# with webhook secret :
docker run --name jblatlantis -p 34141:4141 ${EXPRESS_NODE_APPLICATION_DOCKER_ORG}/atlantis-cresh:0.0.1 server --gh-user=${ATLANTIS_GH_USERNAME} --gh-token=${ATLANTIS_GH_TOKEN} --repo-whitelist=${ATLANTIS_REPO_WHITELIST} --atlantis-url=${ATLANTIS_URL} --gh-webhook-secret=${ATLANTIS_GH_WEBHOOK_SECRET}


echo " Now give atlantis a visit at [$ATLANTIS_URL:34141] "
# http://pegasusio.io:34141

```
* Output that I get, running atlantis without a github webook secret :

```bash
jbl@poste-devops-typique:~/atlantis$ docker run --name jblatlantis -p 34141:4141 ${EXPRESS_NODE_APPLICATION_DOCKER_ORG}/atlantis-cresh:0.0.1 server --gh-user=${ATLANTIS_GH_USERNAME} --gh-token=${ATLANTIS_GH_TOKEN} --repo-whitelist=${ATLANTIS_REPO_WHITELIST} --atlantis-url=${ATLANTIS_URL}
2020/03/21 23:52:21+0000 [WARN] cmd: No GitHub webhook secret set. This could allow attackers to spoof requests from GitHub
2020/03/21 23:52:22+0000 [INFO] server: Atlantis started - listening on port 4141


```

# Configuration d' `Atlantis`

Je cite la documentation :

>
> The config file you pass to `--config` is
> different from the `--repo-config` file.
> The `--config` config file is only used as
> an alternate way of setting `atlantis server` flags.
>
> _Source_ : https://www.runatlantis.io/docs/server-configuration.html#config-file
>

En clair, Atlantis se configure à l'aide de deux fichiers :
* un premier fichier, permet de configurer des paramètres d'exécution qui peuvent être passés :
  * soit par des options GNU "flags" de la commande  `server`. Exemple  `atlantis server --gh-token=$VALEUR_DE_MON_TOKEN`
  * soit par un fichier de configuration dont le chemin est prciésé par l'option GNU `--config`. Exemple `atlantis server --config`:  des options GNU "flags" de la commande  `server`. Exemple  `atlantis server --gh-token=$VALEUR_DE_MON_TOKEN`


```bash
# --
atlantis server --config /path/to/config.yaml --repo-config /path/2/repo-config.yaml
```

* contenu de `/path/to/config.yaml` :

```Yaml
# -- minimal config for atlantis to be able to run on a repo.
#
# Donc ici, toutes les options que j'ai déjà passées à la commande 'server', au docker run :

# ---
#
#
#  --gh-user=${ATLANTIS_GH_USERNAME}
gh-user: "Jean-Baptiste-Lasselle"
#  --gh-token=${ATLANTIS_GH_TOKEN}
gh-token: "3543435415343"
#  --repo-whitelist=${ATLANTIS_REPO_WHITELIST}
repo-whitelist: "ATLANTIS_REPO_WHITELIST_JINJA2_VAR"
#  --atlantis-url=${ATLANTIS_URL}
atlantis-url: "ATLANTIS_URL_JINJA2_VAR"
#  --gh-webhook-secret=${ATLANTIS_GH_WEBHOOK_SECRET}
gh-webhook-secret: "ATLANTIS_GH_WEBHOOK_SECRET_JINJA2_VAR"
```

* contenu de `/path/2/repo-config.yaml` :

```Yaml
# -- minimal config for atlantis to be able to run on a repo.
#
# DOnc ici, toutes les options que j'ai déjà passées à la commande 'server', au docker run :

gh-token:
```


# Minimal Permissions I tested

## Github User Token (developer settings)

![tested gh permissions](https://github.com/pegasus-io/a-k8s-demo/raw/feature/k8s-provisioning/documentation/images/atlantis/ATLANTIS_GH_TOKEN_PERMISSIONS_TEST1.png)

<!--
![tested gh permissions](https://github.com/pegasus-io/a-k8s-demo/raw/develop/documentation/images/atlantis/ATLANTIS_GH_TOKEN_PERMISSIONS_TEST1.png)

![tested gh permissions](https://github.com/pegasus-io/a-k8s-demo/raw/master/documentation/images/atlantis/ATLANTIS_GH_TOKEN_PERMISSIONS_TEST1.png)
-->
