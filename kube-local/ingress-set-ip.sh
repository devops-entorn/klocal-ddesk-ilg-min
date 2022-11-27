#!/bin/bash

export IP_FROM_CONFIG_FILE=$(grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' ./config.yaml)

echo "IP_FROM_CONFIG_FILE=$IP_FROM_CONFIG_FILE"

export INGRESS_PUBLIC_IP=$(kubectl --namespace=ingress-nginx get all | grep LoadBalancer | tr -s ' ' | cut  -d' ' -f3)

echo "INGRESS_PUBLIC_IP=$INGRESS_PUBLIC_IP"

if [ ! -z "$IP_FROM_CONFIG_FILE" ]; then
         sed -i "s/$IP_FROM_CONFIG_FILE/$INGRESS_PUBLIC_IP/g" ./config.yaml
else
         sed -i "s/'INGRESS_PUBLIC_IP': \"\"/'INGRESS_PUBLIC_IP': \"$INGRESS_PUBLIC_IP\"/g" ./config.yaml
fi

NEW_IP_FROM_CONFIG_FILE=$(grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' ./config.yaml)

echo "NEW_IP_FROM_CONFIG_FILE=$NEW_IP_FROM_CONFIG_FILE"

exit 0

