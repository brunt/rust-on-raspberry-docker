[![DockerHub](https://img.shields.io/badge/DockerHub-1.24.0-blue.svg)](https://hub.docker.com/r/ubruntu/rust-raspberry/)


# Cross compiling with `Docker`

The steps for cross compiling your project with the help of docker look like:

1. Pulling the `Docker image` from the dockerhub
2. Running a `Docker container` from that `Docker image` which takes your `rust` project (and it's platform dependencies) and then cross compiles it

You can optionally build the docker image yourself. This may be necessary if depend on stuff
that is not in the image provided on the dockerhub. See section "Building your own Docker image" for
a detailed instruction on how to build the image yourself.

## Cross compiling your project with the image from the dockerhub

You need to pull the image first from the dockerhub (assuming you have docker installed):
```
docker pull ubruntu/rust-raspberry:<version>
```
where `<version>` is the Rust compiler version. The docker images are provided starting from
version 1.12.0.

If you successfully pulled the `Docker image` containing the cross compiler, you can cross compile your project:
```
$ docker run \
    --volume <path to your rust project directory>:/home/cross/project \
    --volume <path to directory containing the platform dependencies>:/home/cross/deb-deps \ # optional, see section "Platform dependencies"
    --volume <path to local cargo registry, e.g. ~/.cargo/registry>:/home/cross/.cargo/registry \ # optional, using cached registry avoids updating on every build
    ubruntu/rust-raspberry:<version>
```

The compiled project can then be found in your `target` directory.

### Platform dependencies (optional)
*NOTE*: Only Raspbian `.deb` files are supported currently (but we appreciate patches for other formats)

Let's say your project uses some crate that depends on having openssl
installed on the system. In this case you have download the corresponding Raspbian `.deb` packages
into a folder on your host system and then mount this directory into your `docker` container (See section "Cross compiling your project ...").

Get these packages either from the raspberry, or download them online.

If you do `apt-cache show libssl1.0.0` on the raspberry, you'll see this in the
output:

    Filename:    pool/main/o/openssl/libssl1.0.0_1.0.1e-2+rvt+deb7u17_armhf.deb

You should be able to find a match for that under ftp.debian.org/debian/pool, so
the resulting URL in this case is

    http://ftp.debian.org/debian/pool/main/o/openssl/libssl-dev_1.0.1e-2+deb7u17_armhf.deb

If it's not there, see if it is still on the raspberry under
`/var/cache/apt/archive`.

If you still can't find it, try searching for the filename online.

## Building your own Docker image
```
$ git clone https://github.com/ubruntu/rust-on-raspberry-docker
$ cd rust-on-raspberry-pi/docker
$ docker build -t rust-raspberry:1.24.0 .
```

By setting different tags for your `Docker image` and `RUST_VERSION` you could easily build images for different version of rust and use them as need.

Cross-compiling with your own build image works exactly as with the one pulled from the dockerhub.
Just replace `ubruntu/rust-raspberry:<version>` with your own image name.

## Credits

I forked this project from https://github.com/Ragnaroek/rust-on-raspberry-docker and modified it until it worked for me. My goal was to add a .sh or .bat file to a rust project and use it to run the compile command specifically for the raspberry pi.
