
# Excellent ce petit article

Le principe :

J'ai un petit serveur chez moi, et je me sers d'AWS juste pour gérer l'aspect DNS :
* Il utilise le service https://icanhazip.com pour récupérer l'adresse IP publique chez lui
* Il utilise AWS pour associer un npm de domaine que j'ai acheté, à une adresse IP particlière, donc il utilsie AWS uniquement pour faire des enregsitrements DNS, `DNS record`
* Sans pour autant avoir la moindre machine virtuelle chez `AWS`.

C'est une solution alternative à la mis een oeuvre d' un client `DynDNS`, typiquement un client `DynDNS`, pour `noip.com`.

Mais cette solution a une dépendance de taille : il faut que le service `icanhazip.com` soit opérationnel.

La solution existe, il faut :

* Déployer un service équivalent à `icanhazip.com`,
* Par exemple sur un `heroku`, mais n'importe où, à la condition qu' il existe un lien réseau, entre la machine dont je veux les metadata réseau `WAN` (par ex. l'adresse IP publique) , et le service, avec un passage obligaoire par le WAN (donc aucune liaison L2, et un passage `BGP`).


## La doc terraform pour l'implémentation du `Terraform External Datasource`

<div id="inner" class="col-sm-8 col-md-9 col-xs-12" role="main">
      <div id="inner-header-grid">
        <div id="external-docs-link">
        </div>
      <h1 id="external-data-source">
  <a name="external-data-source" class="anchor" href="#external-data-source">»</a>
  External Data Source
</h1><div id="inner-quicknav"><span id="inner-quicknav-trigger">Jump to Section<svg width="9" height="5" xmlns="http://www.w3.org/2000/svg"><path d="M8.811 1.067a.612.612 0 0 0 0-.884.655.655 0 0 0-.908 0L4.5 3.491 1.097.183a.655.655 0 0 0-.909 0 .615.615 0 0 0 0 .884l3.857 3.75a.655.655 0 0 0 .91 0l3.856-3.75z" fill-rule="evenodd"></path></svg></span><ul class="dropdown"><li class="level-h2"><a href="#example-usage">
  »
  Example Usage
</a></li><li class="level-h2"><a href="#external-program-protocol">
  »
  External Program Protocol
</a></li><li class="level-h2"><a href="#argument-reference">
  »
  Argument Reference
</a></li><li class="level-h2"><a href="#attributes-reference">
  »
  Attributes Reference
</a></li><li class="level-h2"><a href="#processing-json-in-shell-scripts">
  »
  Processing JSON in shell scripts
</a></li></ul></div></div>


<p>The <code>external</code> data source allows an external program implementing a specific
protocol (defined below) to act as a data source, exposing arbitrary
data for use elsewhere in the Terraform configuration.</p>
<div class="alert alert-warning" role="alert">
<p><strong>Warning</strong> This mechanism is provided as an "escape hatch" for exceptional
situations where a first-class Terraform provider is not more appropriate.
Its capabilities are limited in comparison to a true data source, and
implementing a data source via an external program is likely to hurt the
portability of your Terraform configuration by creating dependencies on
external programs and libraries that may not be available (or may need to
be used differently) on different operating systems.</p>
</div>
<div class="alert alert-warning" role="alert">
<p><strong>Warning</strong> Terraform Enterprise does not guarantee availability of any
particular language runtimes or external programs beyond standard shell
utilities, so it is not recommended to use this data source within
configurations that are applied within Terraform Enterprise.</p>
</div>
<h2 id="example-usage">
  <a name="example-usage" class="anchor" href="#example-usage">»</a>
  Example Usage
</h2>
<div class="highlight"><pre class="highlight hcl"><code><span class="n">data</span> <span class="s2">"external"</span> <span class="s2">"example"</span> <span class="p">{</span>
  <span class="n">program</span> <span class="o">=</span> <span class="p">[</span><span class="s2">"python"</span><span class="p">,</span> <span class="s2">"${path.module}/example-data-source.py"</span><span class="p">]</span>

  <span class="n">query</span> <span class="o">=</span> <span class="p">{</span>
    <span class="c1"># arbitrary map from strings to strings, passed</span>
    <span class="c1"># to the external program as the data query.</span>
    <span class="nb">id</span> <span class="o">=</span> <span class="s2">"abc123"</span>
  <span class="p">}</span>
<span class="p">}</span>
</code></pre></div><h2 id="external-program-protocol">
  <a name="external-program-protocol" class="anchor" href="#external-program-protocol">»</a>
  External Program Protocol
</h2>
<p>The external program described by the <code>program</code> attribute must implement a
specific protocol for interacting with Terraform, as follows.</p>
<p>The program must read all of the data passed to it on <code>stdin</code>, and parse
it as a JSON object. The JSON object contains the contents of the <code>query</code>
argument and its values will always be strings.</p>
<p>The program must then produce a valid JSON object on <code>stdout</code>, which will
be used to populate the <code>result</code> attribute exported to the rest of the
Terraform configuration. This JSON object must again have all of its
values as strings. On successful completion it must exit with status zero.</p>
<p>If the program encounters an error and is unable to produce a result, it
must print a human-readable error message (ideally a single line) to <code>stderr</code>
and exit with a non-zero status. Any data on <code>stdout</code> is ignored if the
program returns a non-zero status.</p>
<p>All environment variables visible to the Terraform process are passed through
to the child program.</p>
<p>Terraform expects a data source to have <em>no observable side-effects</em>, and will
re-run the program each time the state is refreshed.</p>
<h2 id="argument-reference">
  <a name="argument-reference" class="anchor" href="#argument-reference">»</a>
  Argument Reference
</h2>
<p>The following arguments are supported:</p>

<ul>
<li><p><a name="program"></a><a href="#program"><code>program</code></a> - (Required) A list of strings, whose first element is the program
to run and whose subsequent elements are optional command line arguments
to the program. Terraform does not execute the program through a shell, so
it is not necessary to escape shell metacharacters nor add quotes around
arguments containing spaces.</p>
</li>
<li><p><a name="working_dir"></a><a href="#working_dir"><code>working_dir</code></a> - (Optional) Working directory of the program.
If not supplied, the program will run in the current directory.</p>
</li>
<li><p><a name="query"></a><a href="#query"><code>query</code></a> - (Optional) A map of string values to pass to the external program
as the query arguments. If not supplied, the program will receive an empty
object as its input.</p>
</li>
</ul>
<h2 id="attributes-reference">
  <a name="attributes-reference" class="anchor" href="#attributes-reference">»</a>
  Attributes Reference
</h2>
<p>The following attributes are exported:</p>

<ul>
<li><a name="result"></a><a href="#result"><code>result</code></a> - A map of string values returned from the external program.
</li>
</ul>
<h2 id="processing-json-in-shell-scripts">
  <a name="processing-json-in-shell-scripts" class="anchor" href="#processing-json-in-shell-scripts">»</a>
  Processing JSON in shell scripts
</h2>
<p>Since the external data source protocol uses JSON, it is recommended to use
the utility <a href="https://stedolan.github.io/jq/"><code>jq</code></a> to translate to and from
JSON in a robust way when implementing a data source in a shell scripting
language.</p>
<p>The following example shows some input/output boilerplate code for a
data source implemented in bash:</p>
<div class="highlight"><pre class="highlight shell"><code><span class="c">#!/bin/bash</span>

<span class="c"># Exit if any of the intermediate steps fail</span>
<span class="nb">set</span> <span class="nt">-e</span>

<span class="c"># Extract "foo" and "baz" arguments from the input into</span>
<span class="c"># FOO and BAZ shell variables.</span>
<span class="c"># jq will ensure that the values are properly quoted</span>
<span class="c"># and escaped for consumption by the shell.</span>
<span class="nb">eval</span> <span class="s2">"</span><span class="si">$(</span>jq <span class="nt">-r</span> <span class="s1">'@sh "FOO=\(.foo) BAZ=\(.baz)"'</span><span class="si">)</span><span class="s2">"</span>

<span class="c"># Placeholder for whatever data-fetching logic your script implements</span>
<span class="nv">FOOBAZ</span><span class="o">=</span><span class="s2">"</span><span class="nv">$FOO</span><span class="s2"> </span><span class="nv">$BAZ</span><span class="s2">"</span>

<span class="c"># Safely produce a JSON object containing the result value.</span>
<span class="c"># jq will ensure that the value is properly quoted</span>
<span class="c"># and escaped to produce a valid JSON string.</span>
jq <span class="nt">-n</span> <span class="nt">--arg</span> foobaz <span class="s2">"</span><span class="nv">$FOOBAZ</span><span class="s2">"</span> <span class="s1">'{"foobaz":$foobaz}'</span>
</code></pre></div>

    </div>




# L'arcticle original qui m'a donné l'idée (Credits for the original article : https://medium.com/@matzhouse/dynamic-dns-with-terraform-and-route53-3fafe7c68970 )


<div class="z ab ac ae af dc ah ai"><div><div id="e5ce" class="dd de ap ce df b dg dh di dj dk dl dm dn do dp dq"><h1 class="df b dg dr di ds dk dt dm du do dv ap">Dynamic DNS with Terraform and Route53</h1></div><div class="dw"><div class="n dx dy dz ea"><div class="o n"><div><a rel="noopener" href="/@matzhouse?source=post_page-----3fafe7c68970----------------------"><div class="eb ec ed"><div class="bf n ee o p s ef eg eh ei ej cw"><svg width="57" height="57" viewBox="0 0 57 57"><path fill-rule="evenodd" clip-rule="evenodd" d="M28.5 1.2A27.45 27.45 0 0 0 4.06 15.82L3 15.27A28.65 28.65 0 0 1 28.5 0C39.64 0 49.29 6.2 54 15.27l-1.06.55A27.45 27.45 0 0 0 28.5 1.2zM4.06 41.18A27.45 27.45 0 0 0 28.5 55.8a27.45 27.45 0 0 0 24.44-14.62l1.06.55A28.65 28.65 0 0 1 28.5 57 28.65 28.65 0 0 1 3 41.73l1.06-.55z"></path></svg></div><img alt="Mat Evans" class="r ek ed ec" src="https://miro.medium.com/fit/c/96/96/1*48Gdb_J3v9s0AuvraRD5GA.jpeg" width="48" height="48"></div></a></div><div class="el ai r"><div class="n"><div style="flex:1"><span class="cd b ce cf cg ch r ap q"><div class="em n o en"><span class="cd eo ep cf av eq er as at au ap"><a class="bx by bg bh bi bj bk bl bm bn es bq br cb cc" rel="noopener" href="/@matzhouse?source=post_page-----3fafe7c68970----------------------">Mat Evans</a></span><div class="et r bw h"><button class="eu ap q ev ew ex ey ez bn cb fa fb fc fd fe ff fg cd b ce fh fi ch fj fk cr fl fm bq">Follow</button></div></div></span></div></div><span class="cd b ce cf cg ch r ci cj"><span class="cd eo ep cf av eq er as at au ci"><div><a class="bx by bg bh bi bj bk bl bm bn es bq br cb cc" rel="noopener" href="/@matzhouse/dynamic-dns-with-terraform-and-route53-3fafe7c68970?source=post_page-----3fafe7c68970----------------------">Sep 29, 2019</a> <!-- -->·<!-- --> <!-- -->4<!-- --> min read<span style="padding-left:4px"><svg class="star-15px_svg__svgIcon-use" width="15" height="15" viewBox="0 0 15 15" style="margin-top:-2px"><path d="M7.44 2.32c.03-.1.09-.1.12 0l1.2 3.53a.29.29 0 0 0 .26.2h3.88c.11 0 .13.04.04.1L9.8 8.33a.27.27 0 0 0-.1.29l1.2 3.53c.03.1-.01.13-.1.07l-3.14-2.18a.3.3 0 0 0-.32 0L4.2 12.22c-.1.06-.14.03-.1-.07l1.2-3.53a.27.27 0 0 0-.1-.3L2.06 6.16c-.1-.06-.07-.12.03-.12h3.89a.29.29 0 0 0 .26-.19l1.2-3.52z"></path></svg></span></div></span></span></div></div><div class="n fn fo fp fq fr fs ft fu y"><div class="n o"><div class="fv r bw"><a href="//medium.com/p/3fafe7c68970/share/twitter?source=post_actions_header---------------------------" class="bx by bg bh bi bj bk bl bm bn bz ca bq br cb cc" target="_blank" rel="noopener nofollow"><svg width="29" height="29" class="q"><path d="M22.05 7.54a4.47 4.47 0 0 0-3.3-1.46 4.53 4.53 0 0 0-4.53 4.53c0 .35.04.7.08 1.05A12.9 12.9 0 0 1 5 6.89a5.1 5.1 0 0 0-.65 2.26c.03 1.6.83 2.99 2.02 3.79a4.3 4.3 0 0 1-2.02-.57v.08a4.55 4.55 0 0 0 3.63 4.44c-.4.08-.8.13-1.21.16l-.81-.08a4.54 4.54 0 0 0 4.2 3.15 9.56 9.56 0 0 1-5.66 1.94l-1.05-.08c2 1.27 4.38 2.02 6.94 2.02 8.3 0 12.86-6.9 12.84-12.85.02-.24 0-.43 0-.65a8.68 8.68 0 0 0 2.26-2.34c-.82.38-1.7.62-2.6.72a4.37 4.37 0 0 0 1.95-2.51c-.84.53-1.81.9-2.83 1.13z"></path></svg></a></div><div class="fv r bw"><button class="bx by bg bh bi bj bk bl bm bn bz ca bq br cb cc"><svg width="29" height="29" viewBox="0 0 29 29" fill="none" class="q"><path d="M5 6.36C5 5.61 5.63 5 6.4 5h16.2c.77 0 1.4.61 1.4 1.36v16.28c0 .75-.63 1.36-1.4 1.36H6.4c-.77 0-1.4-.6-1.4-1.36V6.36z"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M10.76 20.9v-8.57H7.89v8.58h2.87zm-1.44-9.75c1 0 1.63-.65 1.63-1.48-.02-.84-.62-1.48-1.6-1.48-.99 0-1.63.64-1.63 1.48 0 .83.62 1.48 1.59 1.48h.01zM12.35 20.9h2.87v-4.79c0-.25.02-.5.1-.7.2-.5.67-1.04 1.46-1.04 1.04 0 1.46.8 1.46 1.95v4.59h2.87v-4.92c0-2.64-1.42-3.87-3.3-3.87-1.55 0-2.23.86-2.61 1.45h.02v-1.24h-2.87c.04.8 0 8.58 0 8.58z" fill="#fff"></path></svg></button></div><div class="fv r bw"><a href="//medium.com/p/3fafe7c68970/share/facebook?source=post_actions_header---------------------------" class="bx by bg bh bi bj bk bl bm bn bz ca bq br cb cc" target="_blank" rel="noopener nofollow"><svg width="29" height="29" class="q"><path d="M23.2 5H5.8a.8.8 0 0 0-.8.8V23.2c0 .44.35.8.8.8h9.3v-7.13h-2.38V13.9h2.38v-2.38c0-2.45 1.55-3.66 3.74-3.66 1.05 0 1.95.08 2.2.11v2.57h-1.5c-1.2 0-1.48.57-1.48 1.4v1.96h2.97l-.6 2.97h-2.37l.05 7.12h5.1a.8.8 0 0 0 .79-.8V5.8a.8.8 0 0 0-.8-.79"></path></svg></a></div><div class="fw r"><a href="https://medium.com/m/signin?operation=register&amp;redirect=https%3A%2F%2Fmedium.com%2F%40matzhouse%2Fdynamic-dns-with-terraform-and-route53-3fafe7c68970&amp;source=post_actions_header--------------------------bookmark_sidebar-" class="bx by bg bh bi bj bk bl bm bn bz ca bq br cb cc" rel="noopener"><svg width="25" height="25" viewBox="0 0 25 25"><path d="M19 6a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v14.66h.01c.01.1.05.2.12.28a.5.5 0 0 0 .7.03l5.67-4.12 5.66 4.13a.5.5 0 0 0 .71-.03.5.5 0 0 0 .12-.29H19V6zm-6.84 9.97L7 19.64V6a1 1 0 0 1 1-1h9a1 1 0 0 1 1 1v13.64l-5.16-3.67a.49.49 0 0 0-.68 0z" fill-rule="evenodd"></path></svg></a></div><div class="fx r am"></div></div></div></div></div></div><p id="8179" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">The problem: you want to be able to ssh back home through your DSL/Cable connection to a little server you have running, maybe a raspberry pi or similar but your ISP keeps doing a switcheroo on your IP address.</p><p id="aea4" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">I know, right! How rude!</p><p id="c157" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">Let’s solve this problem with some little bits of terraform and route53.</p><h2 id="ba64" class="gm gn ap ce cd go gp gq gr gs gt gu gv gw gx gy gz" data-selectable-paragraph="">1. Get Terraform</h2><p id="cea0" class="fy fz ap ce ga b gb ha gd hb gf hc gh hd gj he gl cx" data-selectable-paragraph="">Goto <a href="https://www.terraform.io/" class="bx fm hf hg hh hi" target="_blank" rel="noopener nofollow">https://www.terraform.io/</a> and follow the instructions for downloading and installing the cli tool. If you’re unfamiliar with Terraform, it’s just a tool that allows you to programmatically manage infrastructure.</p><p id="c334" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">If that’s gone well you should be able to do the following on your command line</p><pre class="hj hk hl hm hn ho hp hq"><span id="ad49" class="gm gn ap ce hr b ep hs ht r hu" data-selectable-paragraph="">$ terraform<br>Usage: terraform [-version] [-help] &lt;command&gt; [args]</span><span id="59c8" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">The available commands for execution are listed below.<br>The most common, useful commands are shown first, followed by<br>less common or more advanced commands. If you're just getting<br>started with Terraform, stick with the common commands. For the<br>other commands, please read the help and docs before usage.</span><span id="e071" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Common commands:<br>    apply              Builds or changes infrastructure<br>...</span></pre><h2 id="8f72" class="gm gn ap ce cd go gp gq gr gs gt gu gv gw gx gy gz" data-selectable-paragraph="">2. Create the Terraform file that will update your DNS record</h2><p id="e850" class="fy fz ap ce ga b gb ha gd hb gf hc gh hd gj he gl cx" data-selectable-paragraph="">This part is pretty simple, we’re just going to make a text file with some instructions in it that tell Terraform to find our IP on the internet and then set it under a record in Route53.</p><p id="8c23" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">Make a text file in an editor of your choice and put the following in it.</p><pre class="hj hk hl hm hn ho hp hq"><span id="7f1a" class="gm gn ap ce hr b ep hs ht r hu" data-selectable-paragraph=""># Set some defaults for AWS like region.<br>provider "aws" {<br> profile = "default"<br> region  = "eu-west-1"<br>}<br></span><span id="6970" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph=""># Select the correct zone from Route53<br>data "aws_route53_zone" "selected" {<br>  name         = "example.com."<br>  private_zone = false<br>}</span><span id="388c" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph=""># Set a record - home.example.com in this example - that contains # the IP of your home ISP connection<br>resource "aws_route53_record" "home" {<br>  zone_id = "${data.aws_route53_zone.selected.zone_id}"<br>  name    = "home.${data.aws_route53_zone.selected.name}"<br>  type    = "A"<br>  ttl     = "60"<br>  records = ["${chomp(data.http.myip.body)}"]<br>}</span><span id="202f" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph=""># This gets your IP from a simple HTTP request - note it's V4.<br>data "http" "myip" {<br>  url = "<a href="http://ipv4.icanhazip.com" class="bx fm hf hg hh hi" target="_blank" rel="noopener nofollow">http://ipv4.icanhazip.com</a>"<br>}</span></pre><p id="96f7" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">There’s a few things you’ll need to make sure you have access to for this to work. An AWS account is obviously necessary and you’ll need a domain name with a zone setup in Route53 with the name servers set on that domain.</p><h2 id="5ec9" class="gm gn ap ce cd go gp gq gr gs gt gu gv gw gx gy gz" data-selectable-paragraph="">3. Use the terraform app to update the record</h2><p id="7efd" class="fy fz ap ce ga b gb ha gd hb gf hc gh hd gj he gl cx" data-selectable-paragraph="">There are 3steps to getting the Route53 record updated.</p><p id="54db" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">First we need to initialise the current terraform config. This pulls down any plugins it needs and sets up some files so it can keep track of everything.</p><pre class="hj hk hl hm hn ho hp hq"><span id="6273" class="gm gn ap ce hr b ep hs ht r hu" data-selectable-paragraph="">$ terraform init<br><br>Initializing the backend...</span><span id="a085" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Initializing provider plugins...<br>- Checking for available provider plugins...<br>- Downloading plugin for provider "aws" (hashicorp/aws) 2.30.0...<br>- Downloading plugin for provider "http" (hashicorp/http) 1.1.1...</span><span id="41b8" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">The following providers do not have any version constraints in configuration,<br>so the latest version was installed.</span><span id="e1b6" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">To prevent automatic upgrades to new major versions that may contain breaking<br>changes, it is recommended to add version = "..." constraints to the<br>corresponding provider blocks in configuration, with the constraint strings<br>suggested below.</span><span id="d4fc" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">* provider.aws: version = "~&gt; 2.30"<br>* provider.http: version = "~&gt; 1.1"</span><span id="ebb1" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Terraform has been successfully initialized!</span><span id="799d" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">You may now begin working with Terraform. Try running "terraform plan" to see<br>any changes that are required for your infrastructure. All Terraform commands<br>should now work.</span><span id="a0b8" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">If you ever set or change modules or backend configuration for Terraform,<br>rerun this command to reinitialize your working directory. If you forget, other<br>commands will detect it and remind you to do so if necessary.</span></pre><p id="29af" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">Then we’re going to run ‘plan’ which gives us a fairly accurate idea of what’s going to happen when we press the button for real!</p><pre class="hj hk hl hm hn ho hp hq"><span id="a354" class="gm gn ap ce hr b ep hs ht r hu" data-selectable-paragraph="">$ terraform plan<br>Refreshing Terraform state in-memory prior to plan...<br>The refreshed state will be used to calculate this plan, but will not be<br>persisted to local or remote state storage.</span><span id="0ad0" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">data.http.myip: Refreshing state...<br>data.aws_route53_zone.selected: Refreshing state...</span><span id="4560" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">------------------------------------------------------------------------</span><span id="6346" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">An execution plan has been generated and is shown below.<br>Resource actions are indicated with the following symbols:<br>  + create</span><span id="4a60" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Terraform will perform the following actions:</span><span id="efc7" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph=""># aws_route53_record.home will be created<br>  + resource "aws_route53_record" "home" {<br>      + allow_overwrite = (known after apply)<br>      + fqdn            = (known after apply)<br>      + id              = (known after apply)<br>      + name            = "example.com"<br>      + records         = [<br>          + "xxx.xxx.xxx.xxx",<br>        ]<br>      + ttl             = 60<br>      + type            = "A"<br>      + zone_id         = "XXXXXXXXXXX"<br>    }</span><span id="d0de" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Plan: 1 to add, 0 to change, 0 to destroy.</span><span id="e95c" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">------------------------------------------------------------------------</span><span id="0ac2" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Note: You didn't specify an "-out" parameter to save this plan, so Terraform<br>can't guarantee that exactly these actions will be performed if<br>"terraform apply" is subsequently run.</span></pre><p id="79f3" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">This gives us a good idea about what is going to happen. We’re going to be setting an IP (here seen as xxx.xxx.xxx.xxx) for the domain name that we have looked up.</p><p id="51aa" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">Now we can carry on and run the ‘apply’ step.</p><pre class="hj hk hl hm hn ho hp hq"><span id="937b" class="gm gn ap ce hr b ep hs ht r hu" data-selectable-paragraph="">$terraform apply</span><span id="4094" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">data.http.myip: Refreshing state...<br>data.aws_route53_zone.selected: Refreshing state...</span><span id="002e" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">An execution plan has been generated and is shown below.<br>Resource actions are indicated with the following symbols:<br>  + create</span><span id="42a5" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Terraform will perform the following actions:</span><span id="5191" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph=""># aws_route53_record.home will be created<br>  + resource "aws_route53_record" "home" {<br>      + allow_overwrite = (known after apply)<br>      + fqdn            = (known after apply)<br>      + id              = (known after apply)<br>      + name            = "example.com"<br>      + records         = [<br>          + "xxx.xxx.xxx.xxx",<br>        ]<br>      + ttl             = 60<br>      + type            = "A"<br>      + zone_id         = "XXXXXXXXXX"<br>    }</span><span id="c2aa" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Plan: 1 to add, 0 to change, 0 to destroy.</span><span id="e3f5" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Do you want to perform these actions?<br>  Terraform will perform the actions described above.<br>  Only 'yes' will be accepted to approve.</span><span id="f417" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Enter a value: yes</span><span id="e379" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">aws_route53_record.home: Creating...<br>aws_route53_record.home: Still creating... [10s elapsed]<br>aws_route53_record.home: Still creating... [20s elapsed]<br>aws_route53_record.home: Still creating... [30s elapsed]<br>aws_route53_record.home: Creation complete after 33s [id=XXXXXXXXXX_example.com._A]</span><span id="b63f" class="gm gn ap ce hr b ep hv hw hx hy hz ht r hu" data-selectable-paragraph="">Apply complete! Resources: 1 added, 0 changed, 0 destroyed.</span></pre><p id="341b" class="fy fz ap ce ga b gb gc gd ge gf gg gh gi gj gk gl cx" data-selectable-paragraph="">There we have it, the record has been created. Every time this is run it will update the DNS record with the current IP found in the run.</p></div>
