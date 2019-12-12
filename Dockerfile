# golang:latest is not available on an ubuntu:18.04 so we build a golang build container ourselves. This has been done to work around GLIBC Version conflicts.
FROM ubuntu:18.04 AS builder

# Setup build environment
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		build-essential \
        g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
        wget \
        ca-certificates \
        git \
	; \
	rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.13.4
ENV GOLANG_SHA 692d17071736f74be04a72a06dab9cac1cd759377bd85316e52b2227604c004c

# Install go by hand
RUN set -eux; \
    wget -O go.tgz "https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz"; \
    echo "${GOLANG_SHA} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz; \
    export PATH="/usr/local/go/bin:$PATH"; \
    go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin"; \
    chmod -R 777 "$GOPATH"

WORKDIR /app
