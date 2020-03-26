# KubeOne image defintion

Using version `KubeOne` version `0.11.0` : `March 2020`


Steps to build the image :

* get kubeone up n running along with terraofrm in the same container.
* Inside the interactive `kubeone_operator` :
  * create your `aws` account.
  * Search the `IAM` service, and create a user with adminstrative permissions. Once completed, `AWS` will give you the users credentials.
  * Setup your real AWS credentials using `~/.aws/credentials` inside container
  * then run `/kubeonebee/kubeone-prepare.sh` for the first time,
  * and when you will run terraform plan into the `/kubeonebee/kubeone/source/examples/terraform/aws` folder, you will get the following error :

<pre>
bash-5.0$ ls -allh
total 56K
drwxr-xr-x    3 beeio    bumblebe    4.0K Mar 24 11:10 .
drwxr-xr-x   10 beeio    bumblebe    4.0K Mar 24 11:10 ..
drwxr-xr-x    3 beeio    bumblebe    4.0K Mar 24 11:10 .terraform
-rw-r--r--    1 beeio    bumblebe    1.9K Mar 24 11:10 README.md
-rw-r--r--    1 beeio    bumblebe    1.2K Mar 24 11:10 kubeone.prepare.terraform.init.logs
-rw-r--r--    1 beeio    bumblebe     236 Mar 24 11:10 kubeone.prepare.terraform.plan.logs
-rwxr-xr-x    1 beeio    bumblebe    8.4K Mar 24 11:10 main.tf
-rw-r--r--    1 beeio    bumblebe    5.1K Mar 24 11:10 output.tf
-rwxr-xr-x    1 beeio    bumblebe      26 Mar 24 11:10 terraform.tfvars
-rwxr-xr-x    1 beeio    bumblebe    2.5K Mar 24 11:10 variables.tf
-rw-r--r--    1 beeio    bumblebe      48 Mar 24 11:10 versions.tf
bash-5.0$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.aws_ami.ubuntu: Refreshing state...
data.aws_availability_zones.available: Refreshing state...

Error: Error fetching Availability Zones: OptInRequired: You are not subscribed to this service. Please go to http://aws.amazon.com to subscribe.
	status code: 401, request id: fc47c106-e44b-46e2-b58e-6617bd8054a5

  on main.tf line 40, in data "aws_availability_zones" "available":
  40: data "aws_availability_zones" "available" {



Error: OptInRequired: You are not subscribed to this service. Please go to http://aws.amazon.com to subscribe.
	status code: 401, request id: 073fbf03-4c14-4ac5-a58d-f431b8d82a59

  on main.tf line 44, in data "aws_ami" "ubuntu":
  44: data "aws_ami" "ubuntu" {


bash-5.0$ pwd
/kubeonebee/kubeone/source/examples/terraform/aws
bash-5.0$

</pre>

  * So okay, we need to do something about availabitlity zones on `AWS` :
    * region we use is the one for Paris, France, aka `eu-west-3`.
    * one `AWS` availability zone is defined in a region


Okay, the minimal terraform setup for kubeone involves 3 machines, which is :
* the minimum cluster nodes number for a production Kubernetes , as mentioned by the `Kubernetes` documentation itself.
* out of the AWS Free plan.
* So I switched to finding the quickest solution to deploy minikube, which will restrain to only one machine, on AWS EC2 : https://www.radishlogic.com/kubernetes/running-minikube-in-aws-ec2-ubuntu/


## Errors about the format of the public key

```bash
Error: Error launching source instance: InvalidKeyPair.NotFound: The key pair 'creshkey' does not exist
	status code: 400, request id: 15fb460e-c0f4-4f64-aedd-42b19d461b6a

  on main.tf line 16, in resource "aws_instance" "creshVM":
  16: resource "aws_instance" "creshVM" {



Error: Error import KeyPair: InvalidKey.Format: Key is not in valid OpenSSH public key format
	status code: 400, request id: 73ad9ced-394c-49d5-821e-3e2a2a9dc4dd

  on main.tf line 50, in resource "aws_key_pair" "deployer":
  50: resource "aws_key_pair" "deployer" {
```


## The minkube fall back

see `oci/kubeone_operator/terraform.minikube` :
* Le petit article : https://www.radishlogic.com/kubernetes/running-minikube-in-aws-ec2-ubuntu/
* cccc :
