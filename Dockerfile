FROM quay.io/openshift/origin-must-gather:4.5.0 as oc


FROM registry.access.redhat.com/ubi8-minimal:latest

COPY --from=oc /usr/bin/oc /usr/bin/oc
COPY bin/stern_linux_amd64_1.11.0 /usr/bin/stern
COPY sa2kubeconfig.sh /usr/bin/sa2kubeconfig.sh
COPY stern.sh /usr/bin/stern.sh
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN mkdir -p /var/cache/sa2kubeconfig

# 1) Convert SA token to kubeconfig, 2) Run log tail
CMD sa2kubeconfig.sh 1> /dev/null && entrypoint.sh
