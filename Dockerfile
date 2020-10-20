FROM quay.io/openshift/origin-must-gather:4.5.0 as oc

FROM openshift/origin-release:golang-1.14 AS builder
RUN mkdir /go/src/github.com/wercker \
&& cd /go/src/github.com/wercker \
&& git clone https://github.com/konveyor/stern -b konveyor-dev \
&& cd /go/src/github.com/wercker/stern \
&& CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o stern-linux

FROM registry.access.redhat.com/ubi8-minimal:latest
COPY --from=oc /usr/bin/oc /usr/bin/oc
COPY --from=builder /go/src/github.com/wercker/stern/stern-linux /usr/bin/stern
COPY bin/stern_linux_amd64_1.11.0 /usr/bin/stern
COPY sa2kubeconfig.sh /usr/bin/sa2kubeconfig.sh
COPY stern.sh /usr/bin/stern.sh
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN mkdir -p /var/cache/sa2kubeconfig

# 1) Convert SA token to kubeconfig, 2) Run log tail
CMD sa2kubeconfig.sh 1> /dev/null && entrypoint.sh
