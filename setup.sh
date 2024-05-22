#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${RALPM_TMP_DIR}" ]]; then
    echo "RALPM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_INSTALL_DIR}" ]]; then
    echo "RALPM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_BIN_DIR}" ]]; then
    echo "RALPM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/RAL0S/killerbee/releases/download/v3.0.0-beta.2/killerbee_3.0.0-beta.2.tar.gz -O $RALPM_TMP_DIR/killerbee_3.0.0-beta.2.tar.gz
  tar xf $RALPM_TMP_DIR/killerbee_3.0.0-beta.2.tar.gz -C $RALPM_PKG_INSTALL_DIR/
  rm $RALPM_TMP_DIR/killerbee_3.0.0-beta.2.tar.gz

  for tool in zbjammer zbdump zbreplay zbopenear zborphannotify zbpanidconflictflood zbstumbler zbkey zbrealign zbfakebeacon zbid zbconvert zbwardrive zbdsniff zbgoodfind zbcat zbassocflood zbscapy zbwireshark
  do
    echo '#!/usr/bin/env sh' > $RALPM_PKG_BIN_DIR/$tool
    echo "PATH=$RALPM_PKG_INSTALL_DIR/bin:\$PATH $RALPM_PKG_INSTALL_DIR/bin/$tool \"\$@\"" >> $RALPM_PKG_BIN_DIR/$tool
    chmod +x $RALPM_PKG_BIN_DIR/$tool
  done
}

uninstall() {
  rm -rf $RALPM_PKG_INSTALL_DIR/*
  for tool in zbjammer zbdump zbreplay zbopenear zborphannotify zbpanidconflictflood zbstumbler zbkey zbrealign zbfakebeacon zbid zbconvert zbwardrive zbdsniff zbgoodfind zbcat zbassocflood zbscapy zbwireshark
  do
    rm $RALPM_PKG_BIN_DIR/$tool
  done
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1