FROM ubuntu:18.04
RUN apt-get -qq update
RUN apt-get -qq install dovecot-imapd dovecot-lmtpd dovecot-mysql dovecot-common
COPY ./config/dovecot*.* /etc/dovecot/
COPY ./config/conf.d/* /etc/dovecot/conf.d/
RUN mkdir -p $MAILDIR/$DOMAIN_NAME
RUN groupadd -g 5000 vmail
RUN useradd -g vmail -u 5000 vmail -d /var/mail
RUN chown -R vmail:vmail /var/mail
RUN chown -R vmail:dovecot /etc/dovecot
RUN chmod -R o-rwx /etc/dovecot
EXPOSE 143 993
ENTRYPOINT [ "dovecot", "-F" ]
#CMD tail -f /dev/null