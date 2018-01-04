#!/usr/bin/env sh

GRAFANA_URL="http://$GF_SECURITY_ADMIN_USER:$GF_SECURITY_ADMIN_PASSWORD@localhost:3000"

post() {
    curl -s -X POST -d "$1" \
        -H 'Content-Type: application/json;charset=UTF-8' \
        "${GRAFANA_URL}$2" 2> /dev/null
}

if [ ! -f "/var/lib/grafana/.init" ]; then
    exec /run.sh $@ &

    until curl -s "${GRAFANA_URL}/api/datasources" 2> /dev/null; do
        echo "wait for grafana to be ready ..."
        sleep 1
    done
    echo "grafana is ready."

    for DATASOURCE in /etc/grafana/datasources/*; do
        echo "POST datasource spec ${DATASOURCE}"
        post "$(envsubst < ${DATASOURCE})" "/api/datasources"
    done

    for DASHBOARD in /etc/grafana/dashboards/*; do
        echo "POST dashboard spec ${DASHBOARD}"
        post "$(cat ${DASHBOARD})" "/api/dashboards/db"
    done

    touch "/var/lib/grafana/.init"

    kill $(pgrep grafana)
fi

exec /run.sh $@
