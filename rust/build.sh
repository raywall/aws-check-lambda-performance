#!/bin/sh
set -e

mkdir -p "output"
mkdir -p "output/arm"

#builds rust arm using cross
cargo install cross
rustup target add aarch64-unknown-linux-gnu
set RUSTFLAGS="-C target-cpu=neoverse-n1"

# winpty for windows
# winpty cross build --release --target aarch64-unknown-linux-gnu
cross build --release --target aarch64-unknown-linux-gnu

#builds a native binary and zip
docker build -t rust .

#copy from the docker container to host
containerId=$(docker create -ti rust bash)
docker cp ${containerId}:function.zip ./output
docker cp ${containerId}:arm/function.zip ./output/arm
