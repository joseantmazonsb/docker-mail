# What is this?

A simple, quick way to deploy a *dockerized* mail server (SMTP/IMAP) based on postfix and dovecot and managed via VimBAdmin.

# What's with the docker image uploaded to Docker Hub?

**Short answer**: it's a *dummy* image just for you to mount your own configuration files and, well, suit yourself.

**Long answer**: it does not include any configuration files because dovecot, postfix and vimbadmin have A LOT of options. However, the Docker Hub's site redirects you to this repository in case you want to do a fresh start or you just don't have any configuration files. Because I placed variables inside multiple files used to build the inner containers, you can specify your own SASL port, domain name, site name and more, by just exporting environment variables (check out the `mail.env.dist` file), therefore obtaining your own customized configuration files.

Of course, feel free to take what you need and build and upload your own personal image.

# Previous considerations

First of all, we are going to set some ground rules:

+ The *dummy* image uploaded to Docker Hub and the `run-mail-server` tool are both meant to **use SSL/TLS features**. You may just ignore this and edit the Dockerfiles to disable this, but I highly disencourage it. Moreover, if you want to use a reverse proxy for VimBAdmin and run that container with no TLS, that's fine, but keep in mind that the website's content may not be displayed correctly in modern browsers, since you'd be asking for JS and CSS resources via HTTP, and the browser will most likely block the requests, **even though your reverse proxy redirects those requests to the HTTPS endpoint**.

+ 

# Installation

Now, here comes the funny part, and it's actually quite simple, as I stated before.


# Common issues

# Contributions

