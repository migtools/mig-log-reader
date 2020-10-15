server=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT
ca=$(cat /run/secrets/kubernetes.io/serviceaccount/ca.crt)
token=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
namespace=$(cat /run/secrets/kubernetes.io/serviceaccount/namespace)

CONFIGPATH=/var/cache/sa2kubeconfig/kubeconfig-${KSUFFIX}

# Remove existing kubeconfig if exists
rm ${CONFIGPATH} 2> /dev/null

# Touch to avoid "Config not found" err on start up
touch ${CONFIGPATH}

# Generate KUBECONFIG from available SA token and ca.crt
export KUBECONFIG=${CONFIGPATH}
oc config set-cluster default-cluster --server=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT \
    --certificate-authority=/run/secrets/kubernetes.io/serviceaccount/ca.crt

oc config set-credentials default-admin \
    --certificate-authority=/run/secrets/kubernetes.io/serviceaccount/ca.crt \
    --token="$token"

oc config set-context default-system --cluster=default-cluster --user=default-admin
oc config use-context default-system
