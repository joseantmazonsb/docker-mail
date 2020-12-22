FROM ubuntu:latest
RUN apt-get -qq update \
    && apt-get -qq install dovecot-imapd dovecot-lmtpd dovecot-mysql dovecot-common

ENV INSTALL_PATH "/config/dovecot"
ENV TARGET_PATH "/etc/dovecot"

WORKDIR $TARGET_PATH

RUN groupadd -g 5000 vmail \
    && useradd -g vmail -u 5000 vmail -d /var/mail \
    && chown -R vmail:vmail /var/mail \
    && chmod -R o-rwx $TARGET_PATH

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]