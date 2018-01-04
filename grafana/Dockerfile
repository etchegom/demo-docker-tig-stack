FROM grafana/grafana

RUN apt-get update \
    && apt-get install -y curl gettext-base \
    && rm -rf /var/lib/apt/lists/*

COPY dashboards /etc/grafana/dashboards
COPY datasources /etc/grafana/datasources

RUN mkdir /app
COPY entrypoint.sh /app/

WORKDIR /app

ENTRYPOINT ["./entrypoint.sh"]
