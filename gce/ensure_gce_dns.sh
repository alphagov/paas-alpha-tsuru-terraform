#!/bin/bash
set -eu

# $1 GCE zone friendly name (e.g. tsuru2)
# $2 DNS record name
# $3 TTL
# $4 Record Type
# $5 Destination/Value

if [ $# -ne 5 ]; then
  echo "Usage: $0 <gce_friendly_zone_name> <dns_record_name> <ttl> <record_type> <value>"
  exit 2
fi

gce_friendly_name=$1
dns_record_name=$2
ttl=$3
record_type=$4
value=$5

# If there are already changes pending when we start our transaction, it will fail
# with a code 412 - Prerequisites not met error. Should that happen, then we need
# to restart the whole transaction from the beginning, so we wrap the whole thing
# in a while loop.
completed=0
while [ $completed -eq 0 ]
do

# Generate a unique transaction file name
# milliseconds-since-epoch with random uuid suffix
transaction_file=`date +%s%3N-``uuidgen`

# Start a new transaction
trap "gcloud dns record-sets transaction abort --transaction-file $transaction_file -z $gce_friendly_name" ERR
gcloud dns record-sets transaction start --transaction-file $transaction_file -z "$gce_friendly_name"

# Firstly let's check if the record already exists
record_line=$(gcloud dns record-sets --zone "$1" list | awk '$1=="'$dns_record_name'."')

if [ -n "$record_line" ] ; then
  echo "Need to first remove record: ${dns_record_name}"
  gcloud dns record-sets transaction remove \
    --transaction-file $transaction_file \
    -z $gce_friendly_name \
    --name $(echo $record_line | awk {'print $1'}) \
    --ttl $(echo $record_line | awk {'print $3'}) \
    --type $(echo $record_line | awk {'print $2'}) \
    $(echo $record_line | awk {'print $4'})
fi

gcloud dns record-sets transaction add \
  --transaction-file $transaction_file \
  -z $gce_friendly_name \
  --name $dns_record_name \
  --ttl $ttl \
  --type $record_type \
  "$value"


# Catch if we get code: 412 returned when we try to execute the transaction, and if we do..
# then we go right back to the start of the loop

if result=$((gcloud dns record-sets transaction execute --transaction-file $transaction_file -z $gce_friendly_name) 2>&1); then
  echo "DNS change applied successfully"
  completed=1
else
  if [[ $result == *"code: 412"* ]]; then
    echo "Got a 412 error - retry"
    gcloud dns record-sets transaction abort --transaction-file $transaction_file -z $gce_friendly_name
  else
    echo "Change failed to apply"
    exit 1
  fi
fi
done
