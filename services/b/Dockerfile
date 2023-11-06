FROM debian:12-slim

COPY ./service.sh /service.sh
RUN chmod +x /service.sh

ENTRYPOINT ["/service.sh"]
