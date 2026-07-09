#!/usr/bin/env bash

HOST="health.anklab.mywire.org"
IP="100.100.1.1"
PORT=443
HTTPS_URL="https://health.anklab.mywire.org"

PING_INTERVAL=2
TCP_INTERVAL=8
HTTPS_INTERVAL=32

# State
last_ping=0
last_tcp=0
last_https=0

ping_ok=false
tcp_ok=false
https_ok=false

last_output=""

now() { date +%s; }

emit() {
  local new="$1"
  if [[ "$new" != "$last_output" ]]; then
    echo "$new"
    last_output="$new"
  fi
}

check_once() {
  local t output
  t=$(now)

  # ---------- Ping ----------
  if (( t - last_ping >= PING_INTERVAL )); then
    if ping -c1 -W1 "$IP" >/dev/null 2>&1; then
      ping_ok=true
    else
      ping_ok=false
      tcp_ok=false
      https_ok=false
      last_https=0
      last_tcp=0
    fi
    last_ping=$t
  fi

  if ! $ping_ok; then
    output='{"class":"offline","tooltip":"Host unreachable"}'
    emit "$output"
    return
  fi

  # ---------- TCP ----------
  if (( t - last_tcp >= TCP_INTERVAL )); then
    if nc -z -w1 "$HOST" "$PORT" >/dev/null 2>&1; then
      tcp_ok=true
    else
      tcp_ok=false
      https_ok=false
      last_https=0
    fi
    last_tcp=$t
  fi

  if ! $tcp_ok; then
    output='{"class":"degraded-port","tooltip":"Host reachable, port closed"}'
    emit "$output"
    return
  fi

  # ---------- HTTPS ----------
  if (( t - last_https >= HTTPS_INTERVAL )); then
    if curl -fsS --max-time 2 "$HTTPS_URL" >/dev/null; then
      https_ok=true
    else
      https_ok=false
    fi
    last_https=$t
  fi

  if ! $https_ok; then
    output='{"class":"degraded-https","tooltip":"Service up, app unhealthy"}'
  else
    output='{"class":"online","tooltip":"All systems go"}'
  fi

  emit "$output"
}
# -------- Execution modes --------

if [[ "$1" == "--loop" ]]; then
  while true; do
    check_once
    sleep 1
  done
else
  check_once
fi

exit 0
