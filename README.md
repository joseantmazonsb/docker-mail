# What is this?

A simple, quick way to deploy a *dockerized* mail server (SMTP/IMAP) based on postfix and dovecot and managed via [ViMbAdmin](https://www.vimbadmin.net/).

# Key features

The main goal of this project is to offer a complete dockerized IMAP/SMTP server which supports virtual mailboxes, aliases, quotas, etc, and a GUI to manage it all.

The following table serves as a summary of the current state of things:

| Component | Current status |
|-|-|
| IMAP server (Dovecot) | Working |
| SMTP server (Postfix) | Partially working (issues regarding external domains) |
| Web administration (ViMbAdmin) | Working |
| Spam blocker (SpamAssassin) | Planned |
| Webmail client | Future |

# Prerequisites

First of all:

- I assume you know about SPF, DKIM and DMARC. If you don't, you should [check out any online guide](https://www.esecurityplanet.com/applications/how-to-set-up-and-implement-dmarc-email-security/) about it. You will need to place TXT records in your DNS for SPF, DMARC and DKIM, so everybody takes you seriously and your emails are not marked as spam. If you are in a hurry, you can just fill the templates I provide in section [DNS records](#DNS-records).
- You should **use SSL/TLS features**. Of course, you may just ignore this, download the source files and make any changes you need, but I highly disencourage disabling SSL/TLS unless you're just testing stuff out.

# Basic installation

Now, here comes the funny part, and it's actually quite simple.

1. Ensure you have installed `docker` and `docker-compose` in your system.
2. Checkout this repository (or download a release).
3. Enter the root folder of the project.
4. Create your `secrets` files. You can follow the sample structure of `docker-compose.yaml`.
5. Modify `docker-compose.yaml` and `mail.env` files according to your `secrets` files and your own particular scenario (volumes to mount, certificates, etc)
6. Run `docker-compose up -d`.

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
# Environment variables

The following table explains the variables to be filled in `db.env` and `mail.env` files:

| Variable | Explanation |
|-|-|
| `MYSQL_ROOT_PASSWORD_FILE` | The path to the file containing the password for the root user of the mysql/mariadb database. |
| `MYSQL_DATABASE_FILE` | The path to the file containing the name of the database to be used by ViMbAdmin. Currently, **it needs to be `vimbadmin`**. |
| `MYSQL_USER_FILE` | The path to the file containing the name of the mysql user to be used by ViMbadmin. |
| `MYSQL_PASSWORD_FILE` | The path to the file containing password of the mysql user to be used by ViMbAdmin. |
| `DOMAIN_NAME` | Your domain name: something like `example.com`. |

## Reverse proxy

### Apache

### Nginx

# Further steps

- Replace Apache with lighttpd (vimbadmin).
- Add spamassasin container.
- Add webmail.

# Known issues

- If you want to use a reverse proxy for ViMbAdmin and run the ViMbAdmin container with no TLS, that's fine, but keep in mind that the website's content may not be displayed correctly in modern browsers, since you'd be asking for JS and CSS resources via HTTP, and the browser will most likely block the requests, **even though your reverse proxy redirects those requests to the HTTPS endpoint**.

# Notes

- Even though this should provide a good starting point, you may want to do some research and adjust parameters to better fit your own needs. Try and experiment!
- Special thanks to ViMbadmin developers: their project inspired me to do this.
