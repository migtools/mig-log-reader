while true
do
    echo [$(date --rfc-3339=seconds)] Refreshing log tail...
    # Generate kubeconfig from SA token
    sa2kubeconfig.sh 1> /dev/null;
    # Run stern for 10 minutes then reboot
    timeout 10m stern.sh;
done
