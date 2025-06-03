#!/bin/bash

TAC_PLUS_BIN=/tacacs/sbin/tac_plus-ng
CONF_FILE=/etc/tac_plus-ng.cfg

if [[ -f "/run/secrets/tac_plus-ng.cfg" ]]; then
    CONF_FILE=/run/secrets/tac_plus-ng.cfg
fi

# Check configuration file exists
if [[ ! -f "${CONF_FILE}" ]]; then
    echo "No configuration file at ${CONF_FILE}"
    exit 1
fi

# Make the log directories
mkdir -p /var/log/tac_plus-ng

# Check configuration file for syntax errors
${TAC_PLUS_BIN} -P ${CONF_FILE}
if [ $? -ne 0 ]; then
    echo "Invalid configuration file"
    exit 1
fi

echo "Starting tac_plus-ng server..."

# Start the server
exec ${TAC_PLUS_BIN} -f ${CONF_FILE}
