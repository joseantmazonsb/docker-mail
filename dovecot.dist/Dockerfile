FROM ubuntu:18.04
RUN apt-get -qq update
RUN apt-get -qq install dovecot-imapd dovecot-lmtpd dovecot-mysql dovecot-common

ENV TMP_PATH "/tmp/dovecot"
ENV INSTALL_PATH "/etc/dovecot"

COPY ./config/dovecot*.* ${TMP_PATH}/
COPY ./config/conf.d/* ${TMP_PATH}/conf.d/
RUN mkdir -p $MAILDIR/$DOMAIN_NAME
RUN groupadd -g 5000 vmail
RUN useradd -g vmail -u 5000 vmail -d /var/mail
RUN chown -R vmail:vmail /var/mail
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 143 993

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD dovecot -F
#CMD tail -f /dev/null