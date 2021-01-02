FROM ubuntu:latest
RUN apt-get -qq update \
    && apt-get -qq install dovecot-imapd dovecot-lmtpd dovecot-mysql dovecot-common

ENV EXPORTED_PATH "/config"
ENV INNER_PATH "/etc/dovecot"

COPY config/* ${INNER_PATH}/
COPY config/conf.d/* ${INNER_PATH}/conf.d/

RUN groupadd -g 5000 vmail
RUN useradd -g vmail -u 5000 vmail -d /var/mail 

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
