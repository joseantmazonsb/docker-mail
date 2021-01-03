# What is this?

A simple, quick way to deploy a *dockerized* mail server (SMTP/IMAP) based on postfix and dovecot and managed via [ViMbAdmin](https://www.vimbadmin.net/).

# Key features

The main goal of this project is to offer a complete dockerized IMAP/SMTP server which supports virtual mailboxes, aliases, quotas, etc, and a GUI to manage it all.

The following table serves as a summary of the current state of things:

| Component | Status |
|-|-|
| IMAP server (Dovecot) | Working |
| SMTP server (Postfix) | Working |
| Web administration (ViMbAdmin) | Working |
| Spam blocker (SpamAssassin) | Planned |
| Webmail client | Future |

# Prerequisites

- I assume you know about SPF, DKIM and DMARC. If you don't, you should [check out any online guide](https://www.esecurityplanet.com/applications/how-to-set-up-and-implement-dmarc-email-security/) about it. You will need to place TXT records in your DNS for SPF, DMARC and DKIM, so everybody takes you seriously and your emails are not marked as spam. If you are in a hurry, you can just fill the templates I provide in section [DNS records](#DNS-records).

# Tested architectures

| Architecture | Status |
|-|-|
| amd64 | Working |
| aarch64 | Working |
| armhf | Failing* |

\* *There is no mysql/mariadb official docker image for ARMv7 systems. Also, `ubuntu:latest` have issues with this architecture. Nonetheless, I may consider working on a build for this architecture if requested.*

# Building process

Now, here comes the funny part, and it's actually quite simple.

1. Ensure you have `docker` and `docker-compose` installed in your system.
2. Checkout this repository (or download a release).
3. Enter the root folder of the project.
4. Create your `secrets` files. You can follow the sample structure of `docker-compose.yaml`.
5. Modify `docker-compose.yaml` and `mail.env` files according to your `secrets` files and your own particular scenario (volumes to mount, certificates, etc)
6. Run `docker-compose up -d`.

# Environment variables

The following table explains the variables to be filled in `db.env` and `mail.env` files:

| Variable | Explanation |
|-|-|
| `MYSQL_ROOT_PASSWORD_FILE` | The path to the file containing the password for the root user of the mysql/mariadb database. |
| `MYSQL_DATABASE_FILE` | The path to the file containing the name of the database to be used by ViMbAdmin. Currently, **it needs to be `vimbadmin`**. |
| `MYSQL_USER_FILE` | The path to the file containing the name of the mysql user to be used by ViMbadmin. |
| `MYSQL_PASSWORD_FILE` | The path to the file containing password of the mysql user to be used by ViMbAdmin. |
| `DOMAIN_NAME` | Your domain name: something like `example.com`. |

# Configuration files and mail directory

Configuration files are stored, by default, inside `/srv/mailserver` in this way: Postfix's files are stored in `/srv/mailserver/postfix`, Dovecot's files are stored in `/srv/mailserver/dovecot`, and so on. Of course, you can change this whenever you want.

The mail directory or **maildir** is stored inside `/srv/mailserver` by default. For instance, you will find the files for `hello@example.com` in `/srv/mailserver/maildir/example.com/hello`.

The `archive` folder is disabled by default in the dovecot configuration, but can be easily enabled by just uncommenting it in `10-mail.conf`. Moreover, the default quota is set to 1GB (can be overwritten by ViMbAdmin), and the maximun email size is set to 50MB.

# Logging

You can check the docker logs anytime by using `docker logs <container-name>`, but in case you need more detailed information:

- ViMbAdmin logs to `/srv/mailserver/var/log/vimbadmin.log` by default.
- Postfix and OpenDKIM log to `/var/log/syslog` by default, since `/dev/log` is mounted for both containers.
- Dovecot logs to several files inside `/srv/mailserver/dovecot/logs` by default.

# Customization

You may change anything you want, of course, but have in mind that:

- Changing MySQL credentials will only affect the containers which query the database container, not the database container itself. To prevent problems, make sure you update the database container's credentials as well.

- Changing the domain name will probably lead to update all SSL files so that they match the new domain.

# DNS records

You will need to place TXT records in your DNS for SPF, DMARC and DKIM, so everybody likes your emails and they are not marked as spam. 

In case you are in a hurry, I provide a template for every record so you can just fill them up and upload them. However, I recommend doing a little research to make your records fit your exact needings.

## SPF

You can make the TXT entry `example.com` return

```
v=spf1 mx a ~all
```

## DKIM

You can make the TXT entry `mail._domainkey.example.com` return

```
v=DKIM1;h=sha256;k=rsa;t=y;p=<dkim_public_key>
```

## DMARC

You can make the TXT entry `_dmarc.example.com` return

```
v=DMARC1; adkim=r; pct=100; rf=afrf; fo=1;p=quarantine; rua=mailto:admin@example.com; ruf=mailto:admin@example.com;
```

# Known issues

- If you want to use a reverse proxy for ViMbAdmin and run the ViMbAdmin container with no TLS, that's fine, but keep in mind that the website's content may not be displayed correctly in modern browsers, since you'd be asking for JS and CSS resources via HTTP, and the browser will most likely block the requests, **even though your reverse proxy redirects those requests to the HTTPS endpoint**.

# Troubleshooting

If you deploy this scenario and something does not work, try the following:

- Check that your SSL files are where they are supposed to be. If they are not where the `docker-compose.yaml` says they are, docker will just create empty files or folders there.
- Check your DNS records: something might not be in place (SPF, DMARC, DKIM, A records pointing to the mailserver...).
- Check your firewall rules and ensure all redirected ports are accessible.
- Check the logs: it is possible that I missed something (I'm only human).

# Notes

- Even though this should provide a good starting point, you may want to do some research and adjust parameters to better fit your own needs. Feel free to try and experiment!
- Special thanks to ViMbadmin developers: their project inspired me to do this.
