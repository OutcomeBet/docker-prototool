FROM golang:1.10.4-alpine3.8

# prototool
RUN apk --no-cache add git make \
 && mkdir -p /go/src/github.com/uber/prototool \
 && cd /go/src/github.com/uber/prototool \
 && git clone --branch v1.2.0 https://github.com/uber/prototool.git . \
 && make init install

# plugins
RUN go get -u github.com/golang/protobuf/protoc-gen-go \
 && go get -u github.com/gogo/protobuf/protoc-gen-gogo \
 && go get -u github.com/micro/protoc-gen-micro

FROM alpine:3.8
# protoc
RUN apk --no-cache add wget \
 && mkdir -p /protoc \
 && wget https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip -O /tmp/protoc.zip; unzip -d /protoc /tmp/protoc.zip; rm /tmp/protoc.zip

FROM frolvlad/alpine-glibc:alpine-3.8_glibc-2.28
RUN apk --no-cache add ca-certificates make
COPY --from=0 /go/bin/* /usr/local/bin/
COPY --from=1 /protoc/bin/* /usr/local/bin/
COPY --from=1 /protoc/include /usr/local/include
