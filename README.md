# Helm Cheat Sheet

> For Helm 3.

## Table of Contents
1. [Concepts](#concepts)
1. [About the Project](#about-the-project)
2. [Conventions](#conventions)
1. [Use Cases](#use-cases)
3. [Quick Start - Get Interactive with helm !](#quick-start---get-interactive-with-helm-)

## Concepts

#### Quick Helm Definitions

Term     | Description
---      | ---
Helm (helm)    | **Package Manager** for **Kubernetes**.
chart    | Software package for **Kubernetes**.
Release  | A named, deployed instance of the **chart**.
Revision | Snapshot of a **Release** in history.
Repository (repo) | A place to store and search for versioned **charts**. Its an indexed filesystem of `.tgz` archives.
Helm Hub (artifacthub.io) | A portal for finding Helm charts across community **repos**.
Plugin | A Helm client extension providing extra sub-commands or features (e.g. `helm diff`).

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

A Helm **chart** is a software package for Kubernetes.

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

A Helm **Release** is a named, deployed instance of the Chart.

Element of a Release | Description
--- | ---
`hooks`       |       controls the order of templates applied at different stages of the Release lifecycle i.e. pre-install, post-upgrade, pre-rollback. Manifest annotations.
`manifest`    |    templated kubernetes YAML manifests.
`notes`       |      welcome banner and getting started messages shown on successful install or upgrade.
`values`      |      values used to generate the release.

A **Revision** is a snapshot of a **Release** in history.

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

## About the Project

----

## Conventions

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

----

## Quick Start - Get Interactive with helm !

#### Before you begin

> Note: You need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster. If you do not already have a cluster, you can create one by using minikube or you can use one of these Kubernetes playgrounds:

+ [Katacoda](https://www.katacoda.com/courses/kubernetes/playground)
+ [Play with Kubernetes](https://labs.play-with-k8s.com/)

#### Run a helm container
> The fastest feedback is Interactive !

Run an interactive terminal in a new container from the container image `doughgle/helm-cheat-sheet`. The container image has `helm` client pre-installed and helm bash completion pre-configured.


```bash
$ sudo docker run --rm \
-v $HOME/.kube/config:/etc/kubernetes/user.kubeconfig \
-e KUBECONFIG=/etc/kubernetes/user.kubeconfig \
-it doughgle/helm-cheat-sheet bash
```

Use double `<TAB>` to auto-complete `helm` commands.

Example:

```
bash-5.0# helm <TAB><TAB>
completion  dependency  env         helm-git    install     list        plugin      repo        s3          secrets     status      test        upgrade     version     
create      diff        get         history     lint        package     pull        rollback    search      show        template    uninstall   verify
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
