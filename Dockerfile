FROM golang:1.12-alpine
ENV GO111MODULE on
ENV GOPROXY direct
RUN apk --no-cache add curl git
RUN go get github.com/uber/prototool/cmd/prototool@v1.8.1 && \
    go get github.com/micro/protoc-gen-micro@v0.8.0 && \
    go get github.com/golang/protobuf/protoc-gen-go@v1.3.2 && \
    go get github.com/gogo/protobuf/protoc-gen-gogo@v1.3.0

FROM frolvlad/alpine-glibc:latest
RUN apk --no-cache add ca-certificates make
COPY --from=0 /go/bin/* /usr/local/bin/
