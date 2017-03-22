FROM debian:jessie
MAINTAINER John Chambers-Malewig <johncm@rcn.com> 

RUN dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install --no-install-recommends --yes \
		# Install wine and related packages
		wine \
		wine32 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Creating the wine user and setting up dedicated non-root environment: replace 1001 by your user id (id -u) for X sharing.
RUN useradd -u 1001 -d /home/wine -m -s /bin/bash wine
ENV HOME /home/wine
WORKDIR /home/wine

USER wine

ENTRYPOINT [ "wine" ]
