#!/usr/bin/env bash

set -e

# Import configuration
. env.sh

IFS=','

read -ra authn <<< "$authenticators"

for i in "${authn[@]}"; do 

# Generate OpenSSL private key

openssl genrsa -out ca.key 2048

CONFIG="
[ req ]
distinguished_name = dn
x509_extensions = v3_ca
[ dn ]
[ v3_ca ]
basicConstraints = critical,CA:TRUE
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
"

# Generate root CA certificate
openssl req -x509 -new -nodes -key ca.key -sha1 -days 3650 -set_serial 0x0 -out ca.cert \
  -subj "/CN=conjur.authn-k8s.$i/OU=Conjur Kubernetes CA/O=$CONJUR_ACCOUNT" \
  -config <(echo "$CONFIG")

# Verify cert
openssl x509 -in ca.cert -text -noout

# Load variable values
docker exec "$container" evoke variable values add conjur/authn-k8s/"$i"/ca/key "$(cat ca.key)"
docker exec "$container" evoke variable values add conjur/authn-k8s/"$i"/ca/cert "$(cat ca.cert)"

done

sleep 3

docker exec "$container" evoke variable set CONJUR_AUTHENTICATORS "$authenticators"
