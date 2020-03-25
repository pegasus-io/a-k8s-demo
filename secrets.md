# Gestion des secrets

* ccc :

```bash
export OPS_HOME=$(pwd)
export BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS=${OPS_HOME}/.robots/bumblebee/.secrets/

# --- #
# Le(s) robot(s) utiliseront :
#
# >
# > une seule et unique clef SSH ppour faire les commits and push
# > des credentials AWS pour terraform
# > token gitlab, dans de futures versiosn token github
# >
#
# ---
# --- #
# ${OPS_HOME}/.robots/bumblebee/.secrets/.aws
# ${OPS_HOME}/.robots/bumblebee/.secrets/.ssh
# ${OPS_HOME}/.robots/bumblebee/.secrets/.github
# ${OPS_HOME}/.robots/bumblebee/.secrets/.gitlab

#
# Dans le conteneur, si les variables d'environnement pour
# les AWS credentials ne sont pas définies, alors KubeOne
# ira les chercher dans le fichier [~/.aws/credentials]
# je vais donc stocker mes credentiasl AWS dans un
# fichier mappé sur le chemin [~/.aws/credentials] dans le conteneur
#


```
