FROM ubuntu:latest
RUN apt-get -qq update \
    && apt-get -qq install dovecot-imapd dovecot-lmtpd dovecot-mysql dovecot-common

ENV INSTALL_PATH "/mailserver/dovecot"
ENV TARGET_PATH "/etc/dovecot"

WORKDIR $TARGET_PATH

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]