# What is this?

A simple, quick way to deploy a *dockerized* mail server (SMTP/IMAP) based on postfix and dovecot and managed via ViMbAdmin.

# How many custom docker images are there?

Four. I used custom images for Dovecot, Opendkim, Postfix and ViMbAdmin. However, both the database and Memcached use images provided by official sources.

# Prerequisites

First of all:

- You will need to place TXT records in your DNS for SPF, DMARC and DKIM (so google, microsoft and everybody like your emails).
- You will need a wildcard certificate (valid for *.example.com, for instance). If you are to use different certificates for one or more services, you will need to edit the `docker-compose.yaml` file to reflect it. More about this in [Customization](#customization).

- This work is meant to **use SSL/TLS features**. Of course, you may just ignore this, download the source files and make any changes you want, but I highly disencourage disabling SSL/TLS.

# Basic installation

Now, here comes the funny part, and it's actually quite simple.

1. Ensure you have installed `docker` and `docker-compose` in your system.
2. Checkout this repository (or download a release).
3. Enter the root folder of the project.
4. Copy .env.dist files to .env (`cp basic.env.dist basic.env; cp advanced.env.dist advanced.env`) and fill them in a way that suit your needings. 

    *Note: default values for `advanced.env.dist` are perfectly valid and may be leaved unchanged*.
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

    You can also change where mail related files are going to be stored (`/srv/mailserver/maildir` by default) by using `-m` option.

7. Put your DKIM private and public keys inside `/srv/mailserver/opendkim/keys`.
8. Run `CERTS_DIR=your/certs/dir docker-compose up -d`.

# Customization

The main goal of this project is to provide a quick way to set up a mail server for unexperienced users. However, you are free to make as many changes as you wish, and this section is meant to be an introductory guide for you to make some of these changes.

## I already have configuration files, I just want docker (please)

Not to worry, we're still flying half a ship.

If you have your own configuration files for one or more services, that's okay, you're free to use them: just place them inside the `DATA_PATH` folder, keeping in mind the hierarchy we explained in step 6 of installation. However, you should only do this if you know what you're doing, since you may have to modify your files to make all services work as separate containers (and trust me, that can be such a pain).

## I want to use a different folder hierarchy for my files

Sure thing. The name of the folders (`DATA_PATH/dovecot`, `DATA_PATH/postfix`...) does not matter as long as you indicate all of them correctly inside `docker-compose.yaml` file. If you placed dovecot files within `DATA_PATH/dov`, you will need to change `${DATA_PATH}/dovecot` to `${DATA_PATH}/dov` in `docker-compose.yaml`. 

## Certificates

If you don't have a wildcard certificate or you just want to use different certificates for different services, you will probably want to use several `CERTS_DIR` variables, so you can do `${DOV_CERTS_DIR}` for dovecot, `${PFIX_CERTS_DIR}` for postfix, etc. Of course, if you use variables inside the `docker-compose.yaml` file, make sure you give them value when running `docker-compose`, just like we did before.

# Further steps

- Replace Apache with lighttpd (vimbadmin).
- Add spamassasin container.
- Add webmail.

# Known issues

- If you want to use a reverse proxy for ViMbAdmin and run the ViMbAdmin container with no TLS, that's fine, but keep in mind that the website's content may not be displayed correctly in modern browsers, since you'd be asking for JS and CSS resources via HTTP, and the browser will most likely block the requests, **even though your reverse proxy redirects those requests to the HTTPS endpoint**. Yep, I faced that myself.

# Contributions

It's just me at the moment :)
