
#!/bin/bash
set -e

LOCUST="/usr/local/bin/locust"
LOCUS_OPTS="-f ./locustfile.py"
LOCUST_MODE=${LOCUST_MODE:-standalone}

if [[ "$LOCUST_MODE" = "master" ]]; then
    LOCUS_OPTS="$LOCUS_OPTS --master --master-port=8089"
elif [[ "$LOCUST_MODE" = "worker" ]]; then
    # LOCUS_OPTS="$LOCUS_OPTS --slave --master-host=$LOCUST_MASTER --master-port=5557"
    LOCUS_OPTS="$LOCUS_OPTS --slave --master-host=$LOCUST_MASTER "
fi

echo "$LOCUST $LOCUS_OPTS"

$LOCUST $LOCUS_OPTS

exec "$@"
