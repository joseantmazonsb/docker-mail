# What is this?

A simple, quick way to deploy a *dockerized* mail server (SMTP/IMAP) based on postfix and dovecot and managed via ViMbAdmin.

# How many custom docker images are there?

Four. I used custom images for Dovecot, Opendkim, Postfix and ViMbAdmin. However, both the database and Memcached use images provided by official sources.

# Previous considerations

First of all, we are going to set some ground rules:

- This work is meant to **use SSL/TLS features**. Of course, you may just ignore this, download the source files and make any changes you want, but I highly disencourage disabling SSL/TLS.

# Installation

Now, here comes the funny part, and it's actually quite simple, as I stated before.

1. Ensure you have installed `docker` (and `docker-compose` if you are to use it) in your system.
2. If you are going to use your own configuration files, skip steps 3-5, and place them **under the same folder** just like: `parent/dovecot/dov_files`, `parent/postfix/pfix_files` and so on.

    *NOTE: the name of the folders (`parent/dovecot`, `parent/postfix`...) does not matter as long as you indicate all of them correctly when running the containers. If you are to use docker-compose, make sure you set the names in `docker-compose.yaml` accordingly, by changing, for example, `${DATA_PATH}/dovecot` to `${DATA_PATH}/dov`, in case you placed dovecot files inside `parent/dov`.*
3. Copy .env.dist files to .env (`cp basic.env.dist basic.env; cp advanced.env.dist advanced.env`) and fill them in a way that suit your needings. *Note: default values of `advanced.env.dist` are perfectly valid an you may leave them unchanged*.
4. Open `setup-conf` and check that my script does not erase / (it does not, but you should always **check what you are about to execute**).
5. Run `setup-conf` (it can only be ran within the same directory, so it would be `./setup-conf`). You may specify the parent folder which will contain all configuration files (the **data path** from now on) using `-d` option. Notice that this parent folder must be specified when running `docker-compose up`, along with the folder containing your TLS certificates, and it will be `/srv/mailserver` by default.

    *NOTE: the name of the folders (parent/dovecot, parent/postifx...) does not matter as long as you indicate all of them correctly when running the containers. If you are to use docker-compose, make sure you set the names in `docker-compose.yaml` accordingl, by changing, for example, `${DATA_PATH}/dovecot` to `${DATA_PATH}/dov`, in case you placed dovecot files inside `parent/dov`.*
6. Put your DKIM private and public keys inside the opendkim folder of your data path (under `/srv/mailserver/opendkim/keys` if you left it all by default).
7. Run `DATA_PATH=your/data/path CERTS_DIR=your/certs/dir docker-compose up -d` if you are to use docker-compose. If not, well, figure it out, I won't always be there for you.

    *NOTE: If you are using different certificates for one or more services, edit the `docker-compose.yaml` file to reflect it. You would probably need to use several `CERTS_DIR` variables, so you can do `${DOV_CERTS_DIR}` for dovecot, `${PFIX_CERTS_DIR}` for postfix, etc. Of course, if leave them as variables, make sure you give them value when running `docker-compose`, just like we did before.*

# Common issues

- If you want to use a reverse proxy for ViMbAdmin and run the ViMbAdmin container with no TLS, that's fine, but keep in mind that the website's content may not be displayed correctly in modern browsers, since you'd be asking for JS and CSS resources via HTTP, and the browser will most likely block the requests, **even though your reverse proxy redirects those requests to the HTTPS endpoint**. Yep, I faced that myself.

# Contributions

It's just me at the moment :)
