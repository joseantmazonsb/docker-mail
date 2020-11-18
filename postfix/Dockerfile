FROM ubuntu:18.04
RUN apt-get -qq update
RUN apt-get -qq install postfix
COPY ./config/* ./etc/postfix/
EXPOSE 25 465 587
#ENTRYPOINT [ "postfix", "start-fg" ]
CMD tail -f /dev/null