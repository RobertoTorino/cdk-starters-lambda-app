FROM docker.io/library/alpine:14
LABEL version="1.0"
LABEL description="demo"

# copy certificates and install packages
COPY /certs/ZscalerRootCertificate-2048-SHA256.crt /etc/ssl/certs/ca-certificates.crt
COPY /certs/ZscalerRootCertificate-2048-SHA256.crt /usr/local/share/ca-certificates/ca-certificates.crt

RUN apk update && apk upgrade && apk add ca-certificates && update-ca-certificates
RUN apk add --no-cache maven
