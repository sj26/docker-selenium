# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.txt INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM seleniarm/node-base:4.0.0-beta-2-20210319
LABEL authors=rows

USER root

#=========
# Firefox
#=========
RUN apt-get update -qqy \
  && apt-get -qqy install firefox-esr libavcodec-extra \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

ARG TARGETARCH

#============
# GeckoDriver
#============
# For arm64 we're sniffing a compatible binary out of an ubuntu package, don't look too hard!
RUN if [ "$(TARGETARCH)" = "arm64" ]; then \
    curl http://ports.ubuntu.com/pool/universe/f/firefox/firefox-geckodriver_75.0+build3-0ubuntu1_arm64.deb | dpkg-deb --fsys-tarfile - | tar -C / -x ./usr/bin/geckodriver; \
  else \
    wget --no-verbose -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.29.0/geckodriver-v0.29.0-linux64.tar.gz \
    && rm -rf /opt/geckodriver \
    && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
    && rm /tmp/geckodriver.tar.gz \
    && mv /opt/geckodriver /opt/geckodriver-$GK_VERSION \
    && chmod 755 /opt/geckodriver-$GK_VERSION \
    && ln -fs /opt/geckodriver-$GK_VERSION /usr/bin/geckodriver; \
  fi

USER 1200
