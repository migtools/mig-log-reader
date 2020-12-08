# mig-log-reader
Tails and collates logs for Konveyor OpenShift 3->4 Migrations

[Video Demo](https://www.youtube.com/watch?v=d4neJEsAYa8)

## Usage


1. Deploy into your `openshift-migration` namespace after installing migration tools with [mig-operator](https://github.com/konveyor/mig-operator)

2. Tail the combined logs from all mig components

```
# Colorized logs
oc logs -f --selector logreader=mig -n openshift-migration -c color
```

```
# Plain logs
oc logs -f --selector logreader=mig -n openshift-migration -c plain
```

![logs](./doc/images/logs.png)
