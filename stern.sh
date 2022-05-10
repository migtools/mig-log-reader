#!/bin/bash
CONFIGPATH=/var/cache/sa2kubeconfig/kubeconfig-${KSUFFIX}

declare -a labels=("app.kubernetes.io/part-of=openshift-migration" "app.kubernetes.io/instance=velero" "name=restic")

for i in "${labels[@]}"
do
    timeout 1m stern -l $i \
    --color ${STERN_COLOR} \
    --exclude-container discovery \
    --exclude "watch is too old"  \
    --exclude "Found new dockercfg secret" \
    --exclude "specified default backup location" \
    --exclude "needs to be at least 1 backup location" \
    --exclude "No backup locations were ready to be verified" \
    --exclude "Backup cannot be garbage-collected" \
    --exclude "Error checking repository for stale locks" \
    --exclude "Backup has expired" \
    --exclude "error getting backup storage location" \
    --exclude "There is no existing backup storage location set as default" \
    --since 2m \
    --all-namespaces \
    --kubeconfig ${CONFIGPATH} \

done