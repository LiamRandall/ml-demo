#!/usr/bin/env bash

# replaces --ctrl-host
export WASMCLOUD_CTL_HOST=192.168.178.134

export BINDLE_IP_ADDRESS_PORT=192.168.178.24:8080
#export REMOTE_HOST_ID=$(wash ctl get hosts -o json | jq -r ".hosts[0].id")

# wash ctl start provider 192.168.178.24:5000/mlinference:0.1.0 --ctl-host 192.168.178.134 --link-name default --host-id NDJNTOAMF2ZNH6XJY7LSFUBXYITCXXXBQNRFWBY6RJT6YLQAJM57BB52 --timeout-ms 15000
# wash ctl start provider 192.168.178.24:5000/mlinference:0.1.0 --ctl-host 192.168.178.134 --link-name default --host-id NBL6YSUPBZGY677IXMHPKLUE7WNL5FWRGVSJS2RS6LSDSQR75BHCY63R --timeout-ms 15000

# wash ctl get inventory -r 192.168.178.134 NAOMRNNUQRY4LZDZK2LWEP6VKS43C4QRPM3IOPHDOVFWRZG23XGN2LAV

# wash ctl get hosts -r 192.168.178.134

# wash ctl get hosts -r 192.168.178.134 -o json | jq -r ".hosts[0].id"

# curl --silent -T ../images/cat.jpg 192.168.178.134:8078/mobilenetv27/matches | jq

# curl -v POST 192.168.178.134:8078/identity -d '{"dimensions":[1,4],"valueTypes":["ValueF32"],"flags":0,"data":[0,0,128,63,0,0,0,64,0,0,64,64,0,0,128,64]}'

# wash reg push 192.168.178.24:5000/mlinference:0.1.0 ../providers/mlinference/build/mlinference.par.gz --insecure
# wash ctl start provider 192.168.178.24:5000/mlinference:0.1.0 --ctl-host 192.168.178.134 --link-name default --host-id NCGX4Q6A5CSF7WVMSKE7AJSZYHZ5DIP76GI6RMDXR35FI2BE4OGRZSZK --timeout-ms 15000


