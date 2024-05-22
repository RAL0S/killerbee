#!/usr/bin/env bash

set -e

# bzip2 required for extracting micromamba
apt update && apt install bzip2 --yes

wget -qO- https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
export MAMBA_ROOT_PREFIX=./micromamba
eval "$(./bin/micromamba shell hook --shell=bash)"

# gcc => build dependency
micromamba create -n killerbee pyusb pyserial pycrypto libgcrypt gcc conda-pack -c conda-forge --yes
micromamba activate killerbee

# Latest commit on develop branch 13-Aug-2022
pip3 install https://github.com/riverloopsec/killerbee/archive/c4137618263ffdb324ff86ed8a7875c3282fc1f1.tar.gz

micromamba remove gcc --yes
micromamba clean -a --yes

conda-pack --prefix ./micromamba/envs/killerbee/ --output killerbee_3.0.0-beta.2.tar.gz
