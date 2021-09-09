FROM quay.io/openshift/origin-must-gather:4.7.0 as oc

FROM registry.access.redhat.com/ubi8/go-toolset:1.14.7 AS builder
ENV GOPATH=$APP_ROOT
RUN mkdir -p $APP_ROOT/src/github.com/wercker
WORKDIR $APP_ROOT/src/github.com/wercker
RUN git clone https://github.com/konveyor/stern -b konveyor-dev
WORKDIR $APP_ROOT/src/github.com/wercker/stern
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o stern-linux

FROM registry.access.redhat.com/ubi8-minimal:latest
COPY --from=oc /usr/bin/oc /usr/bin/oc
COPY --from=builder /opt/app-root/src/github.com/wercker/stern/stern-linux /usr/bin/stern
COPY sa2kubeconfig.sh /usr/bin/sa2kubeconfig.sh
COPY stern.sh /usr/bin/stern.sh
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN mkdir -p /var/cache/sa2kubeconfig

# 1) Convert SA token to kubeconfig, 2) Run log tail
CMD sa2kubeconfig.sh 1> /dev/null && entrypoint.sh
