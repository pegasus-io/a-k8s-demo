# Kubectl provisioning

In this folder, are versioned the shell script to provision neatly kubectl on your machine.

# Giving access to the cluster, to external users

Tout pour un peu plus sécuriser l'accès :

https://stackoverflow.com/questions/47173463/how-to-access-local-kubernetes-minikube-dashboard-remotely


Notamment, il ya une technique pour donner accès au dashboard, sans kubectl isntallé sur la machiene de l'utilisateur :

* on lance le proxy `kubectl proxy` sur la machine `minikube.pegausio.io` : on sait alors que le proxy est sur le `localhost` de la machine `minikube.pegausio.io`

```bash
kubectl proxy &
```
* on créée un tunnel ssh entre la machine de l'utilisateur et `minikube.pegausio.io` :
```bash
kubectl proxy &
```



### The ssh way

Assuming that you have ssh on your ubuntu box.

* First run `kubectl proxy &` to expose the dashboard on http://localhost:8001
* Then expose the dashboard using ssh's port forwarding, executing:

```bash
ssh -R 30000:127.0.0.1:8001 $USER@192.168.0.20
```

* Now you should access the dashboard from your macbook in your LAN pointing the browser to http://192.168.0.20:30000
* To expose it from outside, just expose the port `30000` using `no-ip.com`, maybe change it to some standard port, like 80.
* Note that isn't the simplest solution but in some places would work without having superuser rights ;)
* You can automate the login after restarts of the ubuntu box using a init script and setting public key for connection.

### Slight variation on the approach above :

Là-dessous, ce que le typer veut dire, avec son histoire de `NodePort`, c'est uqe le dashboard kubernetes est lui-même un déploiement, et que son déploiement implique un `NodePort` définissant le nméro de port de l'appli web qu'es tle dashboard.

Bref, tout ça pour dire que la seule info qu'il voulait partager, ce sont les options ssh qu'il utilise : il ne fait pas pareil que l'autre, son tunnel SSH.

Je pense que sa solution est meilleure, déj)à il utilise une connexion avec uen clef privée SSH....



>
> I have an http web service with `NodePort` `30003`.
>
> I make it available on port 80 externally by running:
>

```bash
sudo ssh -v -i ~/.ssh/id_rsa -N -L 0.0.0.0:80:localhost:30003 ${USER}@$(hostname)
```
