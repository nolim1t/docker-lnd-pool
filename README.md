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

## Todo

- [ ] Test out container builds
- [ ] Document more
- [ ] Set up equivalent github actions
- [ ] Set up github mirroring
