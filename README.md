# Get Interactive with Helm !

> The fastest feedback is Interactive !

## Table of Contents
1. [Concepts](#concepts)
1. [Get Interactive !](#get-interactive-)
1. [About the Project](#about-the-project)
1. [Conventions](#conventions)
1. [Use Cases](#use-cases)

## Concepts
[<sup>Top</sup>](#table-of-contents)

#### Quick Definitions

Term     | Description
---      | ---
Helm (helm)    | **Package Manager** for **Kubernetes**.
chart    | Software package for **Kubernetes**.
Release  | A named, deployed instance of the **chart**.
Revision | Snapshot of a **Release** in history.
Repository (repo) | A place to store and search for versioned **charts**. Its an indexed filesystem of `.tgz` archives.
Helm Hub (artifacthub.io) | A portal for finding Helm charts across community **repos**.
Plugin | A Helm client extension providing extra sub-commands or features (e.g. `helm diff`).

#### Introductory Reading

**Helm** is a **Package Manager** for **Kubernetes**.

Just like:
> YUM is a Package Manager for Fedora and Redhat Linux.
>
> APT and Snap are Package Managers for Ubuntu Linux.
>
> Chocolatey is a Package Manager for Windows.

A **Package Manager** knows how to install, configure, upgrade, verify and uninstall packages and their dependencies.

###### Comparison of Package Managers
Package Manager | Package Type | File Type
--- | --- | ---
Helm | chart (lowercase by convention) | `.tgz` - gzip compressed, tar archive
YUM | RPM | `.rpm`
APT | deb | `.deb`

A Helm **chart** is a software package for Kubernetes. It might be a packaged application like Wordpress, or a middlware service like RabbitMQ.

###### Chart structure

```sh
my-app-chart/
├── Chart.yaml
├── charts                  
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml
```

File/Directory | Description
--- | ---
`my-app-chart/`  | chart name. Must be lowercase letters and numbers and dashes.
`├── Chart.yaml` | contains chart metadata (versions, dependencies, etc).
`├── charts`     | directory containing sub-charts.
`├── templates`  | directory containing golang templates to be pre-processed before posting to the kubernetes API.
`│   ├── NOTES.txt` | welcome banner and getting started messages shown on successful install or upgrade.
`│   ├── _helpers.tpl` | files prefixed with an `_` are pre-processed templates, but *not* sent to the kubernetes API server.
`│   ├── deployment.yaml` | contains templated kubernetes resource definition.
`│   └── tests` | directory containing chart tests to be run by `helm test` on a release.
`│       └── test-connection.yaml` |
`└── values.yaml` | contains key-value pairs to be rendered in templates during Helm pre-processing stage.

A Helm **Release** is a named, deployed instance of the Chart. A Release has the following elements.

Element of a Release | Description
--- | ---
`hooks`       |       controls the order of templates applied at different stages of the Release lifecycle i.e. pre-install, post-upgrade, pre-rollback. Manifest annotations.
`manifest`    |    templated kubernetes YAML manifests.
`notes`       |      welcome banner and getting started messages shown on successful install or upgrade.
`values`      |      values used to generate the release.

A **Revision** is a snapshot of a **Release** in history. The Revision is incremented automatically on upgrade. You can roll back to a chosen revision.

```sh
$ helm history angry-bird
REVISION    UPDATED                     STATUS          CHART             APP VERSION     DESCRIPTION
1           Mon Oct 3 10:15:13 2016     superseded      alpine-0.1.0      1.0             Initial install
2           Mon Oct 3 10:15:13 2016     superseded      alpine-0.1.0      1.0             Upgraded successfully
3           Mon Oct 3 10:15:13 2016     superseded      alpine-0.1.0      1.0             Rolled back to 2
4           Mon Oct 3 10:15:13 2016     deployed        alpine-0.1.0      1.0             Upgraded successfully
```

A **Repository** (or repo) is a place to store and search for versioned **charts**.
Its an indexed filesystem of `.tgz` archives.

**Helm Hub** (now [artifacthub.io](https://artifacthub.io)) is a portal for finding Helm Charts across community **repositories**.

A **Plugin** is a Helm client extension providing extra sub-commands or features (e.g. `helm diff`).

----

## Get Interactive !
[<sup>Top</sup>](#table-of-contents)

#### Before you begin

> Note: You need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster. If you do not already have a cluster, you can create one by using minikube or you can use one of these Kubernetes playgrounds:

+ [Katacoda](https://www.katacoda.com/courses/kubernetes/playground)
+ [Play with Kubernetes](https://labs.play-with-k8s.com/)

#### Run a helm container
> The fastest feedback is Interactive !

Run an interactive terminal in a new container from the container image `doughgle/helm-cheat-sheet`. The container image has `helm` client pre-installed and helm bash completion pre-configured.


```bash
$ sudo docker run --rm \
-v $HOME/.kube/config:/home/getia/.kube/config:ro \
-e KUBECONFIG=/etc/kubernetes/user.kubeconfig \
-it doughgle/get-interactive-helm bash
```

#### Interactive Example

Use double `<TAB>` to auto-complete `helm` commands.

```
bash-5.0# helm <TAB><TAB>
completion  dependency  env         helm-git    install     list        plugin      repo        s3          secrets     status      test        upgrade     version     
create      diff        get         history     lint        package     pull        rollback    search      show        template    uninstall   verify
```
```
bash-5.0$ helm ver
verify   version
```
```
bash-5.0$ helm version
W1219 03:52:04.650624      48 loader.go:223] Config not found: /etc/kubernetes/user.kubeconfig
version.BuildInfo{Version:"v3.3.4", GitCommit:"a61ce5633af99708171414353ed49547cf05013d", GitTreeState:"clean", GoVersion:"go1.14.9"}
```

#### Install a chart

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/nginx
```

Now list the releases to see `my-release`.

```bash
helm ls
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
my-release      default         1               2020-12-17 03:44:34.106476211 +0000 UTC deployed        nginx-8.2.2     1.19.6
controlplane $
```

----

## About the Project
[<sup>Top</sup>](#table-of-contents)

----

## Conventions
[<sup>Top</sup>](#table-of-contents)

#### Semantic Versioning
Helm uses [Semantic Versioning](https://semver.org) for Charts and Helm itself.

The latest version of Helm (at the time of writing) is:
> `3.4.1`
>
> `major.minor.patch+build.metadata`

Examples:
+ Helm `v3.4.1` API is ***not* backwards compatible** with Helm `v2.17.0`. `3` is one `major` version up from `2`.
> However, most Helm 2 Charts should work with Helm 3 (CRDs excepted).
+ Helm `v3.4.0` is four `minor` versions up from `v3.0.3`. Those `minor` changes ***are* backwards compatible**.
+ Helm `v3.0.3` has `3` bug fixes on `v3.0.0`.
+ my-chart `1.17.2+20201008195643.ffe0fa8.11` has dot-delimited build metadata:
  + `20201008195643` timestamp of the build.
  + `ffe0fa8` git commit short hash.
  + `11` build number.

> When SemVer versions are stored in Kubernetes labels, we conventionally alter the + character to an _ character, as labels do not allow the + sign as a value.

#### Chart Naming
The directory that contains a chart MUST have the same name as the chart.
Chart name must be lowercase letters, numbers, and/or dashes
e.g. helm-cheat-sheet

#### Grammar
`helm` is the command line tool.

*Helm* is the project.

The term chart does not need to be capitalized, as it is not a proper noun.

----

## Use Cases
[<sup>Top</sup>](#table-of-contents)

#### Complementary Operations

> [flags] and [global flags] options omitted for brevity

Operation | | Complementary Operation | |
--- | --- | --- | ---
**Install** | `helm install [RELEASE_NAME] [CHART]` | **Uninstall** | `helm uninstall RELEASE_NAME [...]`
**Upgrade** | `helm upgrade [RELEASE] [CHART]` | **Rollback** | `helm rollback <RELEASE> [REVISION]`
**Sign** | `helm package [CHART_PATH] [...] --sign` | **Verify** | `helm verify PATH`

#### Chart Development

Operation | Description | |
--- | --- | ---
 **Create**  | create a new chart with the given name | `helm create NAME`
 **Lint**    | examine a chart for possible issues | `helm lint PATH`
 **Package** | package a chart directory into a chart archive | `helm package [CHART_PATH] [...]`
