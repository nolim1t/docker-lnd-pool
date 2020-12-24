ARG REPO=https://gitlab.com/lncm/upstream-oss/pool.git
ARG VERSION=v0.3.4-alpha
ARG USER=lnpool
ARG DATA=/data

FROM golang:1.14-alpine as builder

ARG REPO
ARG VERSION
ENV GODEBUG netdns=cgo
ENV GO111MODULE on

# Install Libraries
RUN apk add --no-cache --update alpine-sdk \
    git \
    make \
    git && \
    mkdir -p /go/src/github.com/lightninglabs

# Set workdir
WORKDIR /go/src/github.com/lightninglabs

# Checkout repo
RUN git clone $REPO && \
    cd pool && \
    git checkout $VERSION && \
    make install


# Start a new, final image to reduce size.
FROM alpine as final

ARG USER
ARG DATA

LABEL maintainer="nolim1t (hello@nolim1t.co)"

# Expose poold ports (gRPC and REST).
EXPOSE 12010 8281

# Copy the binaries from the builder image.
COPY --from=builder /go/bin/pool /bin/
COPY --from=builder /go/bin/poold /bin/

# Add bash.
RUN apk add --no-cache \
    bash \
    ca-certificates

RUN adduser --disabled-password \
    --home "$DATA" \
    --gecos "" \
    "$USER"
USER $USER

ENTRYPOINT ["poold"]
