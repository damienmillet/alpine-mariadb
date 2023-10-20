FROM alpine:latest

RUN apk update
RUN apk add mysql mysql-client openrc --no-cache 

RUN openrc && touch /run/openrc/softlevel

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["entrypoint.sh"]
CMD ["/bin/sh"]
