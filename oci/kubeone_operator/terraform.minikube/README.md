# AWS Quickstart Terraform scripts

This AWS Quickstart Terraform recipe creates the single node infrastructure minimal needed for `minikube`.

* The example terraform I startedd from : https://medium.com/@sahityamaruvada/spinning-up-instances-with-terraform-in-azure-and-aws-38f251d462e8

[minikube official]: https://kubernetes.io/docs/setup/learning-environment/minikube/

## The Single VM properties


| -                    | **Caractéristiques**   | XXX    | XXX           | XXX      | XXX     | XXX      |
|----------------------|------------------------|:------:|:-------------:|:--------:|:-------:|:--------:|
| **AMI**              | Ubuntu Server 18.04 LTS (HVM), SSD Volume Type | ccccc | `"eu-west-3"` | no       | `"cc3"` | no       |
| **Instance Type**    | t3.micro (2 vCPU, 1GB Memory) | string | `"eu-west-3"` | no       | `"cc3"` | no       |
| **Storage**          | 8 GB (gp2) | string | `"eu-west-3"` | no       | `"cc3"` | no       |
| **Tags**             | <ul><li>Key: Name</li><li>Value: Minikube</li></ul> | string | `"eu-west-3"` | no       | `"cc3"` | no       |
| **Security Group**   | <ul><li>Nom : `"Minikube Security Group"`</li><li>`– SSH, 0.0.0.0/0`</li></ul> | string | `"eu-west-3"` | no       | `"cc3"` | no       |
| **SSH Key Pair**     | paire de clefs du robot **_Bumblebee_** | string | `"eu-west-3"` | no       | `"cc3"` | no       |

* D'après les prix d'`AWS / EC2`, si je prenais une VM `t3.medium`, au prix à la demande, plein pot, sans réduction, et au prix à la demande, j'aurai `0.05 x 750 heures = 37.5 US dollars`, donc moins de `35 euros`.
* Donc si je prends cette limite comme référence objectif, et que je fais un checkup complet de mon compte AWS toutes les semaines, avec un terraform destroy obligatoire, alores  je devrais m'en sortir.
* Je peux monter jusqu'à `37 dollars` par mois, c'est raisonnable, ok, et le coût du POC proposé est dans cette limite :
* Les _minimum hardware requirements_, sont de ` 2GB RAM, 2 CPUS, and a disk of 20GB.` d'après cette source officielle redhat (plutôt fiable) : https://developers.redhat.com/blog/2019/04/16/build-your-kubernetes-armory-with-minikube-kail-and-kubens/


## The first user in the VM

We have all infos at : https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/managing-users.html

* You can't set the first user's name using `terraform`, on AWS,
* instead, eah "_AMI_" has a username for the first user :

>
> Each Linux instance launches with a default Linux system user account.
> The default user name is determined by the AMI that was specified when
> you launched the instance. For `Amazon Linux 2` or the **Amazon Linux AMI**, the
>  user name is `ec2-user`. For `CentOS`, the user name is `centos`. For `Debian`, the
> user name is `admin` or `root`. For `Fedora`, the user name is `ec2-user` or `fedora`.
> For `RHEL`, the user name is `ec2-user` or `root`.
> For `SUSE`, the user name is `ec2-user` or `root`.
> For `Ubuntu`, the user name is `ubuntu`.
>
> Otherwise, if `ec2-user` and `root` don't work, check with
> your **AMI provider**.
>


## AWS Pricing (`march 2020`)

<table cellspacing="0" cellpadding="1">
             <tbody>
              <tr>
               <th><b>Name</b></th>
               <th><b>vCPUs</b></th>
               <th><b>Memory (GiB)</b></th>
               <th>Baseline Performance/vCPU</th>
               <th>CPU Credits earned/hr</th>
               <th>Network burst bandwidth (Gbps)</th>
               <th>EBS burst bandwidth (Mbps)</th>
               <th style="text-align: center;"><b>On-Demand Price/hr*</b></th>
               <th><b>1-yr Reserved Instance Effective Hourly*</b></th>
               <th><b>3-yr Reserved Instance Effective Hourly*</b></th>
              </tr>
              <tr>
               <td style="text-align: center;">t3.nano</td>
               <td style="text-align: center;">2</td>
               <td style="text-align: center;">0.5</td>
               <td style="text-align: center;">5%</td>
               <td style="text-align: center;">6<br> </td>
               <td style="text-align: center;">5</td>
               <td style="text-align: center;">Up to 2,085</td>
               <td style="text-align: center;">$0.0052</td>
               <td style="text-align: center;">$0.003</td>
               <td style="text-align: center;">$0.002</td>
              </tr>
              <tr>
               <td style="text-align: center;">t3.micro</td>
               <td style="text-align: center;">2</td>
               <td style="text-align: center;">1.0</td>
               <td style="text-align: center;">10%</td>
               <td style="text-align: center;">12<br> </td>
               <td style="text-align: center;">5</td>
               <td style="text-align: center;">Up to 2,085</td>
               <td style="text-align: center;">$0.0104</td>
               <td style="text-align: center;">$0.006</td>
               <td style="text-align: center;">$0.005</td>
              </tr>
              <tr>
               <td style="text-align: center;">t3.small</td>
               <td style="text-align: center;">2<br> </td>
               <td style="text-align: center;">2.0</td>
               <td style="text-align: center;">20%</td>
               <td style="text-align: center;">24<br> </td>
               <td style="text-align: center;">5</td>
               <td style="text-align: center;">Up to 2,085</td>
               <td style="text-align: center;">$0.0209</td>
               <td style="text-align: center;">$0.012</td>
               <td style="text-align: center;">$0.008</td>
              </tr>
              <tr>
               <td style="text-align: center;">t3.medium</td>
               <td style="text-align: center;">2</td>
               <td style="text-align: center;">4.0</td>
               <td style="text-align: center;">20%</td>
               <td style="text-align: center;">24<br> </td>
               <td style="text-align: center;">5</td>
               <td style="text-align: center;">Up to 2,085</td>
               <td style="text-align: center;">$0.0418</td>
               <td style="text-align: center;">$0.025</td>
               <td style="text-align: center;">$0.017</td>
              </tr>
              <tr>
               <td style="text-align: center;">t3.large</td>
               <td style="text-align: center;">2</td>
               <td style="text-align: center;">8.0</td>
               <td style="text-align: center;">30%</td>
               <td style="text-align: center;">36<br> </td>
               <td style="text-align: center;">5</td>
               <td style="text-align: center;">Up to 2,780</td>
               <td style="text-align: center;">$0.0835</td>
               <td style="text-align: center;">$0.05</td>
               <td style="text-align: center;">$0.036</td>
              </tr>
              <tr>
               <td style="text-align: center;">t3.xlarge</td>
               <td style="text-align: center;">4</td>
               <td style="text-align: center;">16.0</td>
               <td style="text-align: center;">40%</td>
               <td style="text-align: center;">96<br> </td>
               <td style="text-align: center;">5</td>
               <td style="text-align: center;">Up to 2,780</td>
               <td style="text-align: center;">$0.1670</td>
               <td style="text-align: center;">$0.099</td>
               <td style="text-align: center;">$0.067</td>
              </tr>
              <tr>
               <td style="text-align: center;">t3.2xlarge</td>
               <td style="text-align: center;">8</td>
               <td style="text-align: center;">32.0</td>
               <td style="text-align: center;">40%</td>
               <td style="text-align: center;">192<br> </td>
               <td style="text-align: center;">5</td>
               <td style="text-align: center;">Up to 2,780</td>
               <td style="text-align: center;">$0.3341</td>
               <td style="text-align: center;">$0.199</td>
               <td style="text-align: center;">$0.133</td>
              </tr>
             </tbody>
            </table>

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami | AMI ID, use it to fixate control-plane AMI in order to avoid force-recreation it at later times | string | `""` | no |
| aws\_region | AWS region to speak to | string | `"eu-west-3"` | no |
| cluster\_name | Name of the cluster | string | n/a | yes |
| control\_plane\_type | AWS instance type | string | `"t3.medium"` | no |
| control\_plane\_volume\_size | Size of the EBS volume, in Gb | string | `"100"` | no |
| ssh\_agent\_socket | SSH Agent socket, default to grab from $SSH_AUTH_SOCK | string | `"env:SSH_AUTH_SOCK"` | no |
| ssh\_port | SSH port to be used to provision instances | string | `"22"` | no |
| ssh\_private\_key\_file | SSH private key file used to access instances | string | `""` | no |
| ssh\_public\_key\_file | SSH public key file | string | `"~/.ssh/id_rsa.pub"` | no |
| ssh\_username | SSH user, used only in output | string | `"root"` | no |
| vpc\_id | VPC to use ('default' for default VPC) | string | `"default"` | no |
| worker\_os | OS to run on worker machines | string | `"ubuntu"` | no |
| worker\_type | instance type for workers | string | `"t3.medium"` | no |

## Outputs

| Name | Description |
|------|-------------|
| kubeone\_api | kube-apiserver LB endpoint |
| kubeone\_hosts | Control plane endpoints to SSH to |
| kubeone\_workers | Workers definitions, that will be transformed into MachineDeployment object |


>
> Source (03/2020) : https://github.com/kubermatic/kubeone/blob/master/examples/terraform/aws/README.md
>
