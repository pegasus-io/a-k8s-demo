# Ansible Playbook to install minikube in a standard Linux VM


## From https://kubernetes.io/docs/tasks/tools/install-minikube/
* This installation procedure is a problem in itself : I already provisioned a virtual machine, I don't want the recipe to handle IAAS on my behalf, or I want to be able to customize it easily.
* minikube offers to adavanced users the possibility to do that using the `--vm-driver=none` option
* https://minikube.sigs.k8s.io/docs/reference/drivers/none/


## Using the `--vm-driver=none` option

* First, install minikube as usual :

```bash
export MINIKUBE_VERSION_TAG=latest
# https://github.com/kubernetes/minikube/releases/tag/v1.8.2
export MINIKUBE_VERSION=1.8.2
export MINIKUBE_VERSION_TAG="v${MINIKUBE_VERSION}"

curl -Lo minikube https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION_TAG}/minikube-linux-amd64 \
  && chmod +x minikube

# alsofor the minikube binary to be there :
mv mnikube /usr/local/bin
```

* Launch minikube with the `--vm-driver` option set to `none` :

```bash
sudo minikube start --vm-driver=none --apiserver-ips 127.0.0.1 --apiserver-name localhost
# sudo minikube config set driver none
```


* Complete provision and start test :

```bash
# ---
# True, we're supposed not to use virtualization, still, I
# wanna know where I am and I believe what I see.
echo '---------------------------------------------------------------------------------'
echo '---   VIRUTALIZATION CAPABILITIES OF CONTAINERIZATION HOST [$(hostname)] :'
echo '---------------------------------------------------------------------------------'
grep -E --color 'vmx|svm' /proc/cpuinfo
echo '---------------------------------------------------------------------------------'
echo " Has [$(hostname)] virtuamlization capabilities ?"
egrep -q 'vmx|svm' /proc/cpuinfo && echo yes || echo no
echo '---------------------------------------------------------------------------------'


export MINIKUBE_VERSION_TAG=latest
# https://github.com/kubernetes/minikube/releases/tag/v1.8.2
export MINIKUBE_VERSION=1.8.2
export MINIKUBE_VERSION_TAG="v${MINIKUBE_VERSION}"

curl -Lo minikube https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION_TAG}/minikube-linux-amd64 \
  && chmod +x minikube

# alsofor the minikube binary to be there :
sudo mv ./minikube /usr/local/bin
minikube version
# --- #
# sets the none driver as the default : we don't have to use the '--vm-driver' option again.
# --- #
# jbl@poste-devops-typique:~/minikube$ sudo minikube config set driver none
# ❗  These changes will take effect upon a minikube delete and then a minikube start
# jbl@poste-devops-typique:~/minikube$
# --- clear enough
sudo minikube config set driver none

# Launching minikube
sudo minikube start --apiserver-ips 127.0.0.1 --apiserver-name localhost
sudo minikube start --apiserver-ips 127.0.0.1 --apiserver-name minikube.pegasusio.io

```
* About the minikube start options :

>
>      `--apiserver-ips` `ipSlice`             A set of apiserver IP Addresses which are used in the generated certificate for kubernetes.  This can be used if you want to make the apiserver available from outside the machine (default [])
>      `--apiserver-name` `string`             The apiserver name which is used in the generated certificate for kubernetes.  This can be used if you want to make the apiserver available from outside the machine (default "minikubeCA")
>
> see https://minikube.sigs.k8s.io/docs/reference/commands/start/
>

# Security warning

### The `--vm-driver=none` option 's consequences

En utilsiant cette option, Pour le résumer :
* on a deux problèmes de sécurité :
  * des processus miinikube exposés au monde extérieur, comme l'API server, qui sont exécutés par l'utilsiateur root. Cela est un problème.
  * des credentials token etc... notamment les tokens de la configuration `kubectl`, qui sont démunis de toute protection
* on a des recommandations de l'équipe minkube officielle pour amener des mesures de porotection quant à ces deux axes de vulnérabilité :
  * utiliser un firewall, avec des règles adaptées

Source 1 : https://stackoverflow.com/questions/51708990/why-are-minikube-clusters-launched-with-vm-driver-none-vulnerable-to-csrf

* morceaux choisis :

>
> WARNING: IT IS RECOMMENDED NOT TO RUN THE NONE DRIVER ON PERSONAL WORKSTATIONS
> The ‘none’ driver will run an insecure kubernetes apiserver as root that may leave the host vulnerable to CSRF attacks
>
>
> This security warning about running minikube with the `--vm-driver=none` option, we have a security breach. I need to understand this breach  :
>
> https://stackoverflow.com/questions/51708990/why-are-minikube-clusters-launched-with-vm-driver-none-vulnerable-to-csrf
>
> The documentation on attacks inside the minikube is scarce. Basically when you use --vm-driver=none the kubectl config and credentials will be root owned and will be available in the home directory. You need to move them and set appropriate permissions. Also as the secret tokens that are usually used to protect from those kind of attacks would be easily accessible by the attacker. If you do not move the components and set the permissions they could become a potential vector in using the apiserver as a confused deputy when introducing the request as root.
>
> I think that the most dangerous part is: --vm-driver=none exposes the whole process as root. Your kubeapi is running as root. If an attacker could exploit that he would get control of a process operating inside the kernel that runs as a root - and that as we know makes the attacker the owner of the system and could become a gateway not only for the CSFR attack.
>
> Also it is worth mentioning that security is not a priority concern in minikube as it is mostly tool for learning if you would like something more security focused you could consider kubeadm which is:
>
>
> >
> > a toolkit for bootstrapping a best-practises Kubernetes cluster on existing infrastructure.
> >
>

>
> Decreased security minikube starts services that may be available on the Internet. Please ensure that you have a firewall to protect your host from unexpected access. For instance: apiserver listens on TCP *:8443 kubelet listens on TCP *:10250 and *:10255 kube-scheduler listens on TCP *:10259 kube-controller listens on TCP *:10257 Containers may have full access to your filesystem. Containers may be able to execute arbitrary code on your host, by using container escape vulnerabilities such as `CVE-2019-5736`. Please keep your release of minikube up to date.
>
> See https://minikube.sigs.k8s.io/docs/reference/drivers/none/
>


#### References

* https://medium.com/@nieldw/running-minikube-with-vm-driver-none-47de91eab84c
* Googling : https://www.google.com/search?client=firefox-b-e&ei=6uJ7XvwKyu-ABtDbqdgB&q=install+minikube+linux+without+vm&oq=install+minikube+linux+without+


# Official Minikube full warnings about `--vm-driver=none`

<main class="col-12 col-md-9 col-xl-8 pl-md-5" role="main">
            <nav aria-label="breadcrumb" class="d-none d-md-block d-print-none">
	<ol class="breadcrumb spb-1">














<li class="breadcrumb-item">
	<a href="https://minikube.sigs.k8s.io/docs/">Documentation</a>
</li>




<li class="breadcrumb-item">
	<a href="https://minikube.sigs.k8s.io/docs/reference/">Reference</a>
</li>




<li class="breadcrumb-item">
	<a href="https://minikube.sigs.k8s.io/docs/reference/drivers/">Drivers</a>
</li>




<li class="breadcrumb-item active" aria-current="page">
	<a href="https://minikube.sigs.k8s.io/docs/reference/drivers/none/">none</a>
</li>

	</ol>
</nav>


<div class="td-content">
	<h1>none</h1>
	<div class="lead">Linux none (bare-metal) driver</div>


<h2 id="overview">Overview</h2>

<p>This document is written for system integrators who are familiar with minikube, and wish to run it within a customized VM environment. The <code>none</code> driver allows advanced minikube users to skip VM creation, allowing minikube to be run on a user-supplied VM.</p>

<h2 id="requirements">Requirements</h2>

<p>VM running a systemd-based Linux distribution (<a href="https://github.com/kubernetes/minikube/issues/2704" target="_blank">see #2704</a>)</p>

<h2 id="usage">Usage</h2>

<p>The none driver requires minikube to be run as root, until <a href="https://github.com/kubernetes/minikube/issues/3760" target="_blank">#3760</a> can be addressed.</p>
<div class="highlight"><pre style="background-color:#f8f8f8;-moz-tab-size:4;-o-tab-size:4;tab-size:4"><code class="language-shell" data-lang="shell">sudo minikube start --driver<span style="color:#ce5c00;font-weight:bold">=</span>none</code></pre></div>
<p>To make <code>none</code> the default driver:</p>
<div class="highlight"><pre style="background-color:#f8f8f8;-moz-tab-size:4;-o-tab-size:4;tab-size:4"><code class="language-shell" data-lang="shell">sudo minikube config <span style="color:#204a87">set</span> driver none</code></pre></div>
<h2 id="issues">Issues</h2>

<h3 id="decreased-security">Decreased security</h3>

<ul>
<li>minikube starts services that may be available on the Internet. Please ensure that you have a firewall to protect your host from unexpected access. For instance:

<ul>
<li>apiserver listens on TCP *:8443</li>
<li>kubelet listens on TCP *:10250 and *:10255</li>
<li>kube-scheduler listens on TCP *:10259</li>
<li>kube-controller listens on TCP *:10257</li>
</ul></li>
<li>Containers may have full access to your filesystem.</li>
<li>Containers may be able to execute arbitrary code on your host, by using container escape vulnerabilities such as <a href="https://access.redhat.com/security/vulnerabilities/runcescape" target="_blank">CVE-2019-5736</a>. Please keep your release of minikube up to date.</li>
</ul>

<h3 id="decreased-reliability">Decreased reliability</h3>

<ul>
<li><p>minikube with the none driver may be tricky to configure correctly at first, because there are many more chances for interference with other locally run services, such as dnsmasq.</p></li>

<li><p>When run in <code>none</code> mode, minikube has no built-in resource limit mechanism, which means you could deploy pods which would consume all of the hosts resources.</p></li>

<li><p>minikube and the Kubernetes services it starts may interfere with other running software on the system. For instance, minikube will start and stop container runtimes via systemd, such as docker, containerd, cri-o.</p></li>
</ul>

<h3 id="data-loss">Data loss</h3>

<p>With the <code>none</code> driver, minikube will overwrite the following system paths:</p>

<ul>
<li>/etc/kubernetes - configuration files</li>
</ul>

<p>These paths will be erased when running <code>minikube delete</code>:</p>

<ul>
<li>/data/minikube</li>
<li>/etc/kubernetes/manifests</li>
<li>/var/lib/minikube</li>
</ul>

<p>As Kubernetes has full access to both your filesystem as well as your docker images, it is possible that other unexpected data loss issues may arise.</p>

<h3 id="other">Other</h3>

<ul>
<li><code>-p</code> (profiles) are unsupported: It is not possible to run more than one <code>--driver=none</code> instance</li>
<li>Many <code>minikube</code> commands are not supported, such as: <code>dashboard</code>, <code>mount</code>, <code>ssh</code></li>
<li>minikube with the <code>none</code> driver has a confusing permissions model, as some commands need to be run as root (“start”), and others by a regular user (“dashboard”)</li>
<li>CoreDNS detects resolver loop, goes into CrashLoopBackOff - <a href="https://github.com/kubernetes/minikube/issues/3511" target="_blank">#3511</a></li>

<li><p>Some versions of Linux have a version of docker that is newer than what Kubernetes expects. To overwrite this, run minikube with the following parameters: <code>sudo -E minikube start --driver=none --kubernetes-version v1.11.8 --extra-config kubeadm.ignore-preflight-errors=SystemVerification</code></p></li>

<li><p><a href="https://github.com/kubernetes/minikube/labels/co%2Fnone-driver" target="_blank">Full list of open ‘none’ driver issues</a></p></li>
</ul>

<h2 id="troubleshooting">Troubleshooting</h2>

<ul>
<li>Run <code>minikube start --alsologtostderr -v=4</code> to debug crashes</li>
</ul>



	<div class="text-muted mt-5 pt-3 border-top">Last modified March 4, 2020: <a href="https://github.com/kubernetes/minikube/commit/e2ce45c6f0ca9fe51bd37b2fd478ec4ec69dd181">Switch --vm-driver paramter to --driver (e2ce45c6f)</a>
</div>
</div>


          </main>
