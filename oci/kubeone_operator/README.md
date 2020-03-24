# KubeOne image defintion

Using version `KubeOne` version `0.11.0` : `March 2020`


Steps to build the image :

* get kubeone up n running along with terraofrm in the same container.
* Inside the interactive `kubeone_operator` :
  * create your `aws` account.
  * Search the `IAM` service, and create a user with adminstrative permissions. Once completed, `AWS` will give you the users credentials.
  * Setup your real AWS credentials using `~/.aws/credentials` inside container
  * then run `/kubeonebee/kubeone-prepare.sh` for the first time,
  * and when you will run terraform plan into the `ccc` folder, you will get the following error :

```bash
# --

```
