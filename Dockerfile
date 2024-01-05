FROM golang:1.17.13 as builder
ARG pluginVersion=v0.9.1
COPY . /plugins
RUN cd /plugins && \
    bash build_linux.sh -ldflags "-extldflags -static -X 'github.com/containernetworking/plugins/pkg/utils/buildversion.BuildVersion=${pluginVersion}'"

FROM alpine:3.15

RUN mkdir -p /plugins/bin
COPY --from=builder /plugins/bin/bridge \
    /plugins/bin/host-local \
    /plugins/bin/loopback \
    /plugins/bin/portmap \
    /plugins/bin/bandwidth \
    /plugins/bin/
COPY --from=builder /plugins/scripts/env_prepare.sh /plugins/