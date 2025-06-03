# Compile tac_plus-ng
FROM ubuntu:24.04 AS build

LABEL Name=tac_plus-ng
LABEL Version=1.4.1

ARG SRC_VERSION
ARG SRC_HASH

ADD https://github.com/Longsight/event-driven-servers/archive/refs/tags/$SRC_VERSION.tar.gz /tac_plus-ng.tar.gz

RUN echo "${SRC_HASH}  /tac_plus-ng.tar.gz" | sha256sum -c -

COPY ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources
RUN apt update && \
    apt upgrade -y && \
    apt install -y gcc make perl libldap2-dev bzip2 libdigest-md5-perl libnet-ldap-perl libio-socket-ssl-perl \
      libssl-dev libc-ares-dev libpam0g-dev libpcre2-dev libsctp-dev zlib1g-dev libcurl4-gnutls-dev && \
    tar -xzf /tac_plus-ng.tar.gz && \
    cd /event-driven-servers-$SRC_VERSION && \
    ./configure --prefix=/tacacs && \
    make && \
    make install

# Move to a clean, small image
FROM ubuntu:24.04

LABEL maintainer="Platform Infrastructure <sysadmins@vitrifi.net>>"

COPY --from=build /tacacs /tacacs
COPY docker-entrypoint.sh /docker-entrypoint.sh

COPY ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources
RUN apt update && \
    apt upgrade -y && \
    apt install -y perl libldap2-dev bzip2 libdigest-md5-perl libnet-ldap-perl libio-socket-ssl-perl \
      libssl-dev libc-ares-dev libpam0g-dev libpcre2-dev libsctp-dev zlib1g-dev libcurl4-gnutls-dev && \
    apt autoremove -y && \
    rm -rf /var/cache/apt/*


EXPOSE 49

ENTRYPOINT ["/docker-entrypoint.sh"]
