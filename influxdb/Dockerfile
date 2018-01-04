FROM influxdb:alpine

RUN mkdir /app
COPY entrypoint.sh /app/

WORKDIR /app

ENTRYPOINT ["./entrypoint.sh"]
