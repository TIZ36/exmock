#!/usr/bin/env bash

LOCAL_IP=127.0.0.1
NODE=exmock@${LOCAL_IP}
COOKIE=cookie_online

while getopts "c:l:" flag; do
  case "$flag" in
  l) LIVE=$OPTARG ;;
  c) CMD=$OPTARG ;;
  *) do_usage ;;
  esac
done

function echo_eval() {
  local cmd="$@"
  echo "$cmd"
  eval "$cmd"
}

function do_start() {
  if [ "${LIVE}" = "true" ]; then
    echo_eval iex --name ${NODE} \
      --cookie ${COOKIE} \
      -S mix
  else
    echo_eval elixir --name ${NODE} \
      --cookie ${COOKIE} \
      --no-halt \
      --erl "-detached" \
      -S mix
  fi
}

function do_stop() {
  ERL_INTERFACE=$(erl -noshell -eval 'io:format("~s\n", [code:lib_dir("erl_interface")]), erlang:halt()')
  [ -z "$ERL_INTERFACE" ] && echo "cant find erl_interface!" && exit 1

  ERL_CALL=${ERL_INTERFACE}/bin/erl_call
  RET=$(${ERL_CALL} -name ${NODE} -c ${COOKIE} -r -a "init stop")
  if [ "${RET}" = "ok" ]; then
    RET=$(${ERL_CALL} -name ${NODE} -c ${COOKIE} -r -a "erlang halt")
    if [ -z "${RET}" ]; then
      echo "stop success"
    else
      echo "stop fail, reason ${RET}"
    fi
  else
    echo "stop fail, reason ${RET}"
  fi
}

function do_term() {
  echo_eval iex --name term_$(date +%Y%m%d%H%M%S)@${LOCAL_IP} \
    --cookie ${COOKIE} \
    --remsh ${NODE}
}

function do_usage() {
  echo "usage: ./term.sh"
  echo "       ./start.sh"
  echo "       ./stop.sh"
  echo "       ./start.sh live"
}

case $CMD in
start) do_start ;;
stop) do_stop ;;
term) do_term ;;
help | h | usage) do_usage ;;
*) do_usage ;;
esac
