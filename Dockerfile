FROM golang:1.10.4-alpine3.8
RUN apk --no-cache add git make \
 && mkdir -p /go/src/github.com/uber/prototool \
 && cd /go/src/github.com/uber/prototool \
 && git clone --branch v1.2.0 https://github.com/uber/prototool.git . \
 && make init install

# plugins
RUN go get -u github.com/golang/protobuf/protoc-gen-go \
 && go get -u github.com/gogo/protobuf/protoc-gen-gogo \
 && go get -u github.com/micro/protoc-gen-micro

FROM frolvlad/alpine-glibc:alpine-3.8_glibc-2.28
COPY --from=0 /go/bin/* /usr/local/bin/
RUN apk --no-cache add ca-certificates
ENTRYPOINT ["prototool"]
