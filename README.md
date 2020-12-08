# What is this?

A simple, quick way to deploy a *dockerized* mail server (SMTP/IMAP) based on postfix and dovecot and managed via [ViMbAdmin](https://www.vimbadmin.net/).

# Key features

The main goal of this project is to offer a complete dockerized IMAP/SMTP server which supports virtual mailboxes, aliases, quotas, etc, and a GUI to manage it all.

The following table serves as a summary of the current state of things:

| Component | Current status |
|-|-|
| IMAP server (Dovecot) | Working |
| SMTP server (Postfix) | Working |
| Web administration (ViMbAdmin) | Working |
| Spam blocker (SpamAssassin) | Planned |
| Webmail client | Future |

# Prerequisites

First of all:

- I assume you know about SPF, DKIM and DMARC. If you don't, you should [check out any online guide](https://www.esecurityplanet.com/applications/how-to-set-up-and-implement-dmarc-email-security/) about it. You will need to place TXT records in your DNS for SPF, DMARC and DKIM, so everybody takes you seriously and your emails are not marked as spam. If you are in a hurry, you can just fill the templates I provide in section [DNS records](#DNS-records).
- You should **use SSL/TLS features**. Of course, you may just ignore this, download the source files and make any changes you need, but I highly disencourage disabling SSL/TLS unless you're just testing stuff.
- You will need a wildcard certificate (valid for `*.example.com`, for instance). If you are to use different certificates for one or more services, you will need to edit the `docker-compose.yaml` file to reflect it. More about this in [Customization](#customization).

# Basic installation

Now, here comes the funny part, and it's actually quite simple.

1. Ensure you have installed `docker` and `docker-compose` in your system.
2. Checkout this repository (or download a release).
3. Enter the root folder of the project.
4. Copy .env.dist files to .env (`cp basic.env.dist basic.env; cp advanced.env.dist advanced.env`) and fill them in a way that suit your needings. 

    *Note: default values for `advanced.env.dist` are perfectly valid and may remain unchanged*.
5. Open `setup-conf` and check that my script does not erase / (it does not, but you should always **check what you are about to execute**).
6. Run `./setup-conf`. You may specify the folder which will contain all configuration files (it should be the same as the `DATA_PATH` variable's value inside `docker-compose.yaml`) using `-d` option. Default value is `/srv/mailserver`, so configuration files are stored like:
    ```
    /srv/mailserver
    │
    └───dovecot
    │   │   dovecot.conf
    │   │   ...
    │   
    └───postfix
    │   │   main.cf
    │   │   ...
    |
    └───vimbadmin
    |   |
    |   └─── application
    |   |   |
    |   |   └─── configs
    |   |       |
    |   |       └─ application.ini
    |   |
    |   ...
    |
    ...
    ```
    This means you can change the `DATA_PATH` folder, but it's inner structure must remain intact: dovecot files must go inside dovecot folder, postfix files must be located inside postfix folder, and so on.

    Moreover, you can also change the location of the mail directory (`/srv/mailserver/maildir` by default) using `-m` option.

7. Put your DKIM private and public keys inside `/srv/mailserver/opendkim/keys`.
8. Run `CERTS_DIR=your/certs/dir docker-compose up -d`.

# DNS records

You will need to place TXT records in your DNS for SPF, DMARC and DKIM, so everybody takes you seriously and your emails are not marked as spam. 

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
# Customization

This project is primarily oriented to users with few experience or people who like simple, plug and play stuff. However, you are free to make as many changes as you wish, and this section is meant to be an introductory guide for you to make some of these changes.

## I already have configuration files, I just want docker (please)

Not to worry, we're still flying half a ship.

If you have your own configuration files for one or more services, that's okay, you're free to use them: just place them inside the `DATA_PATH` folder, keeping in mind the hierarchy we explained in step 6 of installation. However, you should only do this if you know what you're doing, since you may have to modify your files to make all services work as separate containers (and trust me, that can be such a pain).

## I want to use a different folder hierarchy for my files

Sure thing. The name of the folders (`DATA_PATH/dovecot`, `DATA_PATH/postfix`...) does not matter as long as you indicate all of them correctly inside `docker-compose.yaml` file. For instance, if you placed dovecot files within `DATA_PATH/dov`, you will need to change `${DATA_PATH}/dovecot` to `${DATA_PATH}/dov` in `docker-compose.yaml`. 

## Certificates

If you don't have a wildcard certificate or you just want to use different certificates for different services, you will probably want to use several `CERTS_DIR` variables, so you can do `${DOV_CERTS_DIR}` for dovecot, `${PFIX_CERTS_DIR}` for postfix, etc. Of course, if you use variables inside the `docker-compose.yaml` file, make sure you give them value when running `docker-compose`, just like we did before. Moreover, if you are to use the configuration files I provide, you will need to replace all occurrences of `CERTS_DIR` with the variables or values you choose, and remember to add those new variables to `basic.env` if you are to use `run-conf` with new variables inside the configuration files.

## Environment files

There are two environment files used to generate the custom configuration files and pass configuration parameters to some containers: `basic.env` and `advanced.env`.

### Basic

The following table explains the variables to be filled in `basic.env` file:

| Variable | Explanation |
|-|-|
| `MYSQL_ROOT_PASSWORD` | The password for the root user of the mysql/mariadb database. |
| `MYSQL_DATABASE` | The name of the database to be used by ViMbadmin. Currently it needs to be `vimbadmin`. |
| `MYSQL_USER` | The name of the mysql user to be used by ViMbadmin. |
| `MYSQL_PASSWORD` | The password of the mysql user to be used by ViMbAdmin. |
| `DOMAIN_NAME` | Your domain name: something like `example.com`. |
| `VIRTUALHOST_NAME` | The name of virtualhost to be used to access ViMbAdmin's administration website: to access ViMbAdmin from `vimbadmin.example.com` you must put `vimbadmin` in here. |
| `CERTS_DIR` | The path to the folder containing your wildcard certificate and its private key. Certificate's file name must be `fullchain.pem` and it must be a PEM file which contains the fullchain (hello there captain obvious). On the other hand, the file containing the private key must be a PEM file named `privkey.pem`. |

### Advanced

The following table explains the variables to be filled in `advanced.env` file. Default values should work just fine, and unless you need to do something very specific, you will rarely want to change any of these.

| Variable | Explanation |
|-|-|
| `SASL_PORT` | SASL port to be used by Dovecot (and Postfix in order to connect to Dovecot's SASL service). |
| `LMTP_PORT` | LMTP port to be used by Dovecot (and Postfix in order to connect to Dovecot's LMTP service). |
| `DKIM_PORT` | Port to be used by opendkim (and Postfix in order to connect to opendkim). |
| `MAILDIR` | Path to the folder which will act as default root mail directory for all users. The actual default folder for a given user would be `MAILDIR/<domain>/<username>`. |
| `HOMEDIR` | Path to the folder which will act as default root home directory for all users. The actual default folder for a given user would also be `MAILDIR/<domain>/<username>`. |
| `VMAIL_USER` | The Unix user to be used by Dovecot to own all files. |
| `VMAIL_UID` | UID (Unique identifier) of `VMAIL_USER`. |
| `VMAIL_GROUP` | The Unix group to be used by Dovecot to own all files. |
| `VMAIL_GID` | GID (Group identifier) of `VMAIL_GROUP`. |

## Reverse proxy

### Apache

# Further steps

- Replace Apache with lighttpd (vimbadmin).
- Add spamassasin container.
- Add webmail.
- Reverse proxy with nginx.

# Known issues

- If you want to use a reverse proxy for ViMbAdmin and run the ViMbAdmin container with no TLS, that's fine, but keep in mind that the website's content may not be displayed correctly in modern browsers, since you'd be asking for JS and CSS resources via HTTP, and the browser will most likely block the requests, **even though your reverse proxy redirects those requests to the HTTPS endpoint**. Yep, I faced that myself.

# Notes

- Even though this should provide a good starting point, you may want to do some research and adjust parameters to better fit your own needs. Try and experiment!
- Special thanks to ViMbadmin developers: their project inspired me to do this.

# Contributions

It's just me at the moment :)
