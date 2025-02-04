FROM alpine:3.15.4 as alpine
RUN apk add -U --no-cache ca-certificates

FROM alpine:3.15.4
EXPOSE 3000

ENV GODEBUG netdns=go

COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ARG ARCH=amd64
ADD release/linux/${ARCH}/drone-runner-ssh /bin/
ENTRYPOINT ["/bin/drone-runner-ssh"]
