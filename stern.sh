CONFIGPATH=/var/cache/sa2kubeconfig/kubeconfig-${KSUFFIX}

stern "migration-controller|migration-ui|restic|velero" \
--color ${STERN_COLOR} \
--exclude-container discovery \
--exclude "watch is too old"  \
--exclude "Found new dockercfg secret" \
--since 5s \
--kubeconfig ${CONFIGPATH} \
