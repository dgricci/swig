% SWIG
% Didier Richard
% rév. 0.0.1 du 17/07/2016
% rév. 0.0.2 du 20/10/2016
% rév. 0.0.3 du 19/02/2017
% rév. 0.0.4 du 11/03/2017

---

# Building #

```bash
$ docker build -t dgricci/swig:$(< VERSION) .
$ docker tag dgricci/swig:$(< VERSION) dgricci/swig:latest
```

## Behind a proxy (e.g. 10.0.4.2:3128) ##

```bash
$ docker build \
    --build-arg http_proxy=http://10.0.4.2:3128/ \
    --build-arg https_proxy=http://10.0.4.2:3128/ \
    -t dgricci/swig:$(< VERSION) .
$ docker tag dgricci/swig:$(< VERSION) dgricci/swig:latest
```

## Build command with arguments default values ##

```bash
$ docker build \
    --build-arg WHICH_VERSION=2.21 --build-arg WHICH_DOWNLOAD_URL=https://ftp.gnu.org/gnu/which/which-2.21.tar.gz \
    --build-arg BOOST_VERSION=1_61_0 --build-arg BOOST_DOWNLOAD_URL=https://downloads.sourceforge.net/boost/boost_1_61_0.tar.gz \
    --build-arg PCRE_VERSION=8.39 --build-arg PCRE_DOWNLOAD_URL=https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz \
    --build-arg SWIG_VERSION=3.0.10 --build-arg SWIG_DOWNLOAD_URL=https://downloads.sourceforge.net/swig/swig-3.0.10.tar.gz \
    -t dgricci/swig:$(< VERSION) .
$ docker tag dgricci/swig:$(< VERSION) dgricci/swig:latest
```

# Use #

See `dgricci/jessie` README for handling permissions with dockers volumes.

```bash
$ docker run --rm dgricci/swig

SWIG Version 3.0.12

Compiled with g++ [x86_64-pc-linux-gnu]

Configured options: +pcre

Please see http://www.swig.org for reporting bugs and further information
```

__Et voilà !__


_fin du document[^pandoc_gen]_

[^pandoc_gen]: document généré via $ `pandoc -V fontsize=10pt -V geometry:"top=2cm, bottom=2cm, left=1cm, right=1cm" -s -N --toc -o swig.pdf README.md`{.bash}
