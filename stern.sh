CONFIGPATH=/var/cache/sa2kubeconfig/kubeconfig-${KSUFFIX}

stern "migration-controller|migration-ui|registry|restic|velero" \
--color ${STERN_COLOR} \
--exclude-container discovery \
--exclude "watch is too old"  \
--exclude "level=debug msg=.*s3aws.Stat" \
--exclude "Found new dockercfg secret" \
--exclude "Ignoring unrecognized environment variable REGISTRY" \
--since 5s \
--kubeconfig ${CONFIGPATH} \