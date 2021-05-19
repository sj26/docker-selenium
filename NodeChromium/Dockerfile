# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.txt INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM seleniarm/node-base:4.0.0-beta-2-20210319
LABEL authors=rows

USER root

#============================================
# Chromium
# Obtain Chromium version from: https://packages.debian.org/search?keywords=chromium
#============================================
RUN echo "deb http://http.us.debian.org/debian/ testing non-free contrib main" >> /etc/apt/sources.list \
  && apt-get update -qqy \
  && apt-get -qqy install chromium=89.0.4389.82-1 \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#=================================
# Chromium Launch Script Wrapper
#=================================
COPY wrap_chromium_binary /opt/bin/wrap_chromium_binary
RUN /opt/bin/wrap_chromium_binary

#============================================
# Chrome webdriver
#============================================
RUN apt-get update -qqy \
  && apt-get -qqy install chromium-driver \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

USER 1200
