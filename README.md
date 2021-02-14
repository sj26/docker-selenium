# Multi-arch Docker images for the Selenium Grid Server

This is a fork of the [official selenium docker images][official] with
highly experimental multi-arch support for Chromium and Firefox.

  [official]: https://github.com/SeleniumHQ/docker-selenium

## Quick start

1. Start a Docker container with Firefox

``` bash
$ docker run -d -p 4444:4444 --shm-size 2g seleniarm/standalone-firefox
# OR
$ docker run -d -p 4444:4444 -v /dev/shm:/dev/shm seleniarm/standalone-firefox
```

2. Point your WebDriver tests to http://localhost:4444/wd/hub

3. That's it! 

To inspect visually the browser activity, see the [Debugging](#debugging) section for details.

## Standalone

![Firefox](https://raw.githubusercontent.com/alrra/browser-logos/main/src/firefox/firefox_24x24.png) Firefox 
``` bash
$ docker run -d -p 4444:4444 -v /dev/shm:/dev/shm seleniarm/standalone-firefox
```

![Chromium](https://raw.githubusercontent.com/alrra/browser-logos/main/src/chromium/chromium_24x24.png) Chromium
``` bash
$ docker run -d -p 4444:4444 -v /dev/shm:/dev/shm seleniarm/standalone-chromium
```


