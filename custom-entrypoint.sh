#!/bin/sh
set -e

if [ -n ${AMZN_ES_ENDPOINT} ]; then
        sed -i -e 's~AMZN_ES_ENDPOINT~'${AMZN_ES_ENDPOINT}'~g' /fluentd/etc/fluentd.conf
fi
if [ -n ${AMZN_ES_REGION} ]; then
        sed -i -e 's~AMZN_ES_REGION~'${AMZN_ES_REGION}'~g' /fluentd/etc/fluentd.conf
fi
if [ -n ${ACCESS_KEY} ]; then
        sed -i -e 's~ACCESS_KEY~'${ACCESS_KEY}'~g' /fluentd/etc/fluentd.conf
fi
if [ -n ${SECRET_KEY} ]; then
        sed -i -e 's~SECRET_KEY~'${SECRET_KEY}'~g' /fluentd/etc/fluentd.conf
fi

# quote original entrypoint.sh
DEFAULT=/etc/default/fluentd

if [ -r $DEFAULT ]; then
    set -o allexport
    . $DEFAULT
    set +o allexport
fi

# If the user has supplied only arguments append them to `fluentd` command
if [ "${1#-}" != "$1" ]; then
    set -- fluentd "$@"
fi

# If user does not supply config file or plugins, use the default
if [ "$1" = "fluentd" ]; then
    if ! echo $@ | grep ' \-c' ; then
       set -- "$@" -c /fluentd/etc/${FLUENTD_CONF}
    fi

    if ! echo $@ | grep ' \-p' ; then
       set -- "$@" -p /fluentd/plugins
    fi
fi

# run as root to write buffer file
exec su-exec root "$@"
