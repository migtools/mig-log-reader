#!/bin/bash
CONFIGPATH=/var/cache/sa2kubeconfig/kubeconfig-${KSUFFIX}

timeout 3m stern -l app.kubernetes.io/part-of=openshift-migration \
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
--since 5s \
--all-namespaces \
--kubeconfig ${CONFIGPATH} \

timeout 3m stern -l app.kubernetes.io/instance=velero \
--color ${STERN_COLOR} \
--since 5s \
--kubeconfig ${CONFIGPATH} \

timeout 3m stern -l name=restic \
--color ${STERN_COLOR} \
--since 5s \
--kubeconfig ${CONFIGPATH} \