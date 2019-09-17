from bitnami/postgresql:11
USER root

RUN adduser --gecos "" --disabled-login --home /home/diaspora diaspora
RUN createuser -U postgres -p5430 diaspora
RUN createdb -U postgres -p5430 diaspora
