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
# I'll use [https://github.com/pegasus-io/example-cresh-atlantic-infra] as the git repo that is watched
# So I could give to Atlantis, all repos from my [pegasus-io] Github Org, like this :
export ATLANTIS_REPO_WHITELIST="github.com/pegasus-io/*"
# But I will give to Atlantis, only the repos I need to version my
# terraform state, [https://github.com/pegasus-io/example-cresh-atlantic-infra] like this :
export ATLANTIS_REPO_WHITELIST="github.com/pegasus-io/example-cresh-atlantic-infra"



# ----
# without webhook secret :
docker run --name jblatlantis -p 34141:4141 ${EXPRESS_NODE_APPLICATION_DOCKER_ORG}/atlantis-cresh:0.0.1 server --gh-user=${ATLANTIS_GH_USERNAME} --gh-token=${ATLANTIS_GH_TOKEN} --repo-whitelist=${ATLANTIS_REPO_WHITELIST} --atlantis-url=${ATLANTIS_URL}

# ----
# with webhook secret :
# docker run --name jblatlantis -p 34141:4141 ${EXPRESS_NODE_APPLICATION_DOCKER_ORG}/atlantis-cresh:0.0.1 server --gh-user=${ATLANTIS_GH_USERNAME} --gh-token=${ATLANTIS_GH_TOKEN} --repo-whitelist=${ATLANTIS_REPO_WHITELIST} --atlantis-url=${ATLANTIS_URL} --gh-webhook-secret=${ATLANTIS_GH_WEBHOOK_SECRET}


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

* Contenu de exemple de `/path/2/repo-config.yaml` :

```Yaml
# repos lists the config for specific repos.
repos:
  # id can either be an exact repo ID or a regex.
  # If using a regex, it must start and end with a slash.
  # Repo ID's are of the form {VCS hostname}/{org}/{repo name}, ex.
  # github.com/runatlantis/atlantis.
  #
  # JBL : for all of the repos of the Git Service Provider user, I can use this regular experession (without the simple quotes) : '/.*/'
- id: /.*/


  # apply_requirements sets the Apply Requirements for all repos that match.
  apply_requirements: [approved, mergeable]

  # workflow sets the workflow for all repos that match.
  # This workflow must be defined in the workflows section.
  workflow: custom

  # allowed_overrides specifies which keys can be overridden by this repo in
  # its atlantis.yaml file.
  allowed_overrides: [apply_requirements, workflow]

  # allow_custom_workflows defines whether this repo can define its own
  # workflows. If false (default), the repo can only use server-side defined
  # workflows.
  allow_custom_workflows: true

  # id can also be an exact match.
# - id: github.com/myorg/specific-repo
- id: github.com/pegasus-io/example-cresh-atlantic-infra

# workflows lists server-side custom workflows
workflows:
  custom:
    plan:
      steps:
      # --- #
      # this will run the 'my-custom-command' before terraform init
      # - run: my-custom-command arg1 arg2
      # go get all dependencies inside the atlantis.yaml specoamizing atlantis ' behavior for each repo :
      - run: go get SSH_URI_TO_ATLANTIS_WATCHED_GIT_JINJA2_VAR && go get ${SSH_URI_TO_ANSIBLE_HELM_OPERATOR_JINJA2_VAR

      - init
      # --- #
      # This will tell atlantis to run the
      # 'terraform plan' command with desired args
      #
      - plan:
          extra_args: ["-lock", "false"]
      # --- #
      # this would run the 'my-other-command' after terraform plan.
      # - run: my-other-command arg1 arg2
      # this will generate the run the 'my-other-command' after terraform plan.
      - run: echo 'okay atlantis plan completed jbl'

    apply:
      steps:
      # this will... well just run me.
      - run: echo hi
      - apply
      # --- #
      # This will run the echo command after terraform apply command has completed.
      - run: echo 'okay atlantis apply completed jbl'
```


# Minimal Permissions I tested

## Github User Token (developer settings)

![tested gh permissions](https://github.com/pegasus-io/a-k8s-demo/raw/feature/k8s-provisioning/documentation/images/atlantis/ATLANTIS_GH_TOKEN_PERMISSIONS_TEST1.png)

<!--
![tested gh permissions](https://github.com/pegasus-io/a-k8s-demo/raw/develop/documentation/images/atlantis/ATLANTIS_GH_TOKEN_PERMISSIONS_TEST1.png)

![tested gh permissions](https://github.com/pegasus-io/a-k8s-demo/raw/master/documentation/images/atlantis/ATLANTIS_GH_TOKEN_PERMISSIONS_TEST1.png)
-->
