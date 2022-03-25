#!/usr/bin/env bash
set -eo pipefail

function usage() {
  echo "Usage: installgo.sh [<options>]"
  echo ""
  echo "Options:"
  echo "    -h, --help                               Print this help message"
  echo "    --force                                  Force update"
}

function main() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --force)
        installgo
        exit 0
        ;;
      -h | --help)
        usage
        exit 0
        ;;
    esac
    shift
  done

  if ! command go version &>/dev/null; then
    echo "go not installed, installing: "
    installgo
  else
    echo "nothing to do"
  fi
  exit 0
}

installgo ()
{
  if which wget >/dev/null ; then
    echo "Downloading via wget."
    wget -q -O - https://git.io/vQhTU | bash 
  elif which curl >/dev/null ; then
    echo "Downloading via curl."
    curl -L https://git.io/vQhTU | bash
  else 
    echo "unable to install go, missing curl or wget"
  fi
}

main "$@"
