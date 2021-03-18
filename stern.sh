#!/bin/bash
CONFIGPATH=/var/cache/sa2kubeconfig/kubeconfig-${KSUFFIX}

stern -l app.kubernetes.io/part-of=openshift-migration \
--color ${STERN_COLOR} \
--exclude-container discovery \
--exclude "watch is too old"  \
--exclude "Found new dockercfg secret" \
--since 5s \
--all-namespaces \
--kubeconfig ${CONFIGPATH} \
