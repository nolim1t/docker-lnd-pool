# LND Pool Auto-build


[![pipeline status](https://gitlab.com/nolim1t/docker-lnd-pool/badges/master/pipeline.svg)](https://gitlab.com/nolim1t/docker-lnd-pool/-/commits/master)


## Abstract

This project automagically builds LND pool and pushes it to the gitlab container registry.

## Building

The below builds whatever is defined in the dockerfile

```bash
docker build -t nolim1t/pool:latest .
```

## Running

Running the container

```bash
# Get version
docker run --rm -it --name pool \
    -v $HOME/.pool:/data/.pool \
    nolim1t/pool:latest --version

# Help
docker run --rm -it --name pool \
    -v $HOME/.pool:/data/.pool \
    nolim1t/pool:latest --help
```

## Docker Compose

This spawns up LND, LND Unlock, and LND pool.

Default configuration as host networking and neutrino

### Configuration notes

#### LND

Create a directory in `${HOME}/.lnd` and a file called `lnd.conf`

You can grab a sample from [this repo](https://github.com/lncm/thebox-compose-system/blob/master/lnd/lnd.conf)

#### LND Unlock

Create a directory called `${HOME}/.secrets` and put your password in a file called `lnd-password.txt` which should live in the secrets directory.

#### Pool

Create a directory called `${HOME}/.pool` and put a file called `poold.conf` in it

This is quite new to me as of now. Configuration to be tested.

##### Config Samples

For a detail configuration spec, see the [upstream](https://github.com/lightninglabs/pool/blob/ae48cf330ff929a23b5fee16ae101f75cd400808/config.go#L83) repository

```
[Application Options]
; default settings for now
network=mainnet
rpclisten=localhost:12010"
restlisten=localhost:8281

; Assume that everything is on the same machine
[lnd]
lnd.host=localhost:10009
lnd.macaroondir=/lnd/data/chain/bitcoin/mainnet
lnd.tlspath=/lnd
```

### Example file

```yaml
version: "3.8"
services:
    lnd:
        image: lncm/lnd:v0.11.1-experimental
        container_name: lnd
        network_mode: host
        stop_grace_period: 10m30s
        restart: unless-stopped
        volumes:
            - "${HOME}/.lnd:/data/.lnd"
    lnd-unlock:
        image: lncm/lnd-unlock:1.0.2
        container_name: lnd-unlock
        network_mode: host
        depends_on: [ lnd ]
        restart: unless-stopped
        volumes:
            - "${HOME}/.lnd:/lnd"
            - "${HOME}/.secrets:/secrets"
        environment:
            NETWORK: mainnet
            LNDHOSTNAME: lnd
            HOSTIPPORT: localhost:8080
    pool:
        image: registry.gitlab.com/nolim1t/docker-lnd-pool:latest
        depends_on: [ lnd ]
        container_name: pool
        network_mode: host
        restart: unless-stopped
        stop_grace_period: 1m30s
        volumes:
            - "${HOME}/.pool:/data/.pool"
```

## Todo

- [x] Test out container builds
- [x] Document more
- [ ] Work out how poold works with testnet
- [ ] Set up equivalent github actions
- [ ] Set up github mirroring
