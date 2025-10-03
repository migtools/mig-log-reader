FROM registry.redhat.io/openshift4/ose-must-gather:v4.7 as oc

FROM brew.registry.redhat.io/rh-osbs/openshift-golang-builder:rhel_8_golang_1.24 AS builder
COPY . /workspace
RUN mkdir -p /go/src/github.com/wercker/stern/ &&  tar -cf - /workspace/stern/* | tar --strip-components=2 -xvf - -C /go/src/github.com/wercker/stern/ && tar -cf - /workspace/stern/vendor/* | tar --strip-components=2 -xvf - -C /go/src/
WORKDIR /workspace/stern/
RUN cd /workspace/stern/ && GO111MODULE=off CGO_ENABLED=0 GOOS=linux go build -mod=readonly -a -ldflags '-extldflags "-static"' -o ./stern-linux

FROM registry.redhat.io/ubi8/ubi-minimal
COPY --from=oc /usr/bin/oc /usr/bin/oc
COPY --from=builder /workspace/sa2kubeconfig.sh /usr/bin/sa2kubeconfig.sh
COPY --from=builder /workspace/stern.sh /usr/bin/stern.sh
COPY --from=builder /workspace/entrypoint.sh /usr/bin/entrypoint.sh
COPY --from=builder /workspace/stern/stern-linux /usr/bin/stern
COPY LICENSE /licenses/
RUN mkdir -p /var/cache/sa2kubeconfig

USER 65534:65534

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
