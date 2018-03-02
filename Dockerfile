FROM debian:stretch
ARG RUST_VERSION=stable
ENV HOME=/home/cross
RUN mkdir -p $HOME
RUN apt-get update
RUN apt-get install -y curl git gcc xz-utils gcc-arm-linux-gnueabihf
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN $HOME/.cargo/bin/rustup target add armv7-unknown-linux-gnueabihf
COPY conf/cargo-config $HOME/.cargo/config
COPY bin $HOME/bin
ENV PATH=$HOME/bin:$PATH
ENTRYPOINT ["run.sh"]
CMD ["help"]
