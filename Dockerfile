
FROM certbot/certbot

RUN apk --no-cache add bash git tini nano ca-certificates openssh-client && update-ca-certificates
RUN mkdir -p ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts


RUN apk --no-cache add py3-pip
RUN pip install certbot-dns-hetzner
RUN apk del py3-pip

ADD crontab.txt /etc/crontabs/root
ADD script.sh /script.sh
ADD entry.sh /entry.sh
RUN chmod 755 /script.sh /entry.sh

ENTRYPOINT ["/sbin/tini", "--", "/entry.sh"]
CMD ["bash"]