#!/bin/bash

cd ./kube-local/
./ingress-set-ip.sh
./start-k8s-entorn.sh

exit 0
