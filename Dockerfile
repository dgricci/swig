## Dockerfile for swig environment
FROM dgricci/build-jessie:0.0.1
MAINTAINER Didier Richard <didier.richard@ign.fr>

# install libpython2.7-dev to prevent fatal error when compiling boost
# link python headers into /usr/include
RUN \
    apt-get -qy update && \
    apt-get -qy install --no-install-recommends \
        libpython2.7-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev && \
    rm -rf /var/lib/apt/lists/* && \
    { \
        cd /usr/include ; \
        find ./python2.7/ -name "*.h" -exec ln -s {} . \; ; \
    }

## different versions - use argument when defined otherwise use defaults
# http://ftp.gnu.org/gnu/which/which-2.21.tar.gz + .sig
# http://downloads.sourceforge.net/boost/boost_1_61_0.tar.bz2
# ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2 + .sig
# http://downloads.sourceforge.net/swig/swig-3.0.10.tar.gz
ARG WHICH_VERSION
ENV WHICH_VERSION ${WHICH_VERSION:-2.21}
ARG WHICH_DOWNLOAD_URL
ENV WHICH_DOWNLOAD_URL ${WHICH_DOWNLOAD_URL:-https://ftp.gnu.org/gnu/which/which-$WHICH_VERSION.tar.gz}
ARG BOOST_VERSION
ENV BOOST_VERSION ${BOOST_VERSION:-1_61_0}
ARG BOOST_DOWNLOAD_URL
ENV BOOST_DOWNLOAD_URL ${BOOST_DOWNLOAD_URL:-https://downloads.sourceforge.net/boost/boost_$BOOST_VERSION.tar.gz}
ARG PCRE_VERSION
ENV PCRE_VERSION ${PCRE_VERSION:-8.39}
ARG PCRE_DOWNLOAD_URL
ENV PCRE_DOWNLOAD_URL ${PCRE_DOWNLOAD_URL:-https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$PCRE_VERSION.tar.gz}
ARG SWIG_VERSION
ENV SWIG_VERSION ${SWIG_VERSION:-3.0.10}
ARG SWIG_DOWNLOAD_URL
ENV SWIG_DOWNLOAD_URL ${SWIG_DOWNLOAD_URL:-https://downloads.sourceforge.net/swig/swig-$SWIG_VERSION.tar.gz}

WORKDIR /tmp

RUN \
    wget --no-verbose "$WHICH_DOWNLOAD_URL" && \
    tar xzf which-$WHICH_VERSION.tar.gz && \
    rm -f which-$WHICH_VERSION.tar.gz && \
    { \
        cd which-$WHICH_VERSION ; \
        ./configure --prefix=/usr && make && make install ; \
        cd .. ; \
        rm -fr which-$WHICH_VERSION ; \
    } && \
    wget --no-verbose "$BOOST_DOWNLOAD_URL" && \
    tar xzf boost_$BOOST_VERSION.tar.gz && \
    rm -f boost_$BOOST_VERSION.tar.gz && \
    { \
        cd boost_$BOOST_VERSION ; \
        sed -e '/using python/ s@;@: /usr/include/python${PYTHON_VERSION/3*/${PYTHON_VERSION}m} ;@' -i bootstrap.sh ; \
        sed -e '1 i#ifndef Q_MOC_RUN' -e '$ a#endif' -i boost/type_traits/detail/has_binary_operator.hpp ; \
        ./bootstrap.sh --prefix=/usr && ./b2 stage threading=multi link=shared && ./b2 install threading=multi link=shared ; \
        cd .. ; \
        rm -fr boost_$BOOST_VERSION ; \
    } && \
    wget --no-verbose "$PCRE_DOWNLOAD_URL" && \
    tar xzf pcre-$PCRE_VERSION.tar.gz && \
    rm -f pcre-$PCRE_VERSION.tar.gz && \
    { \
        cd pcre-$PCRE_VERSION ; \
        ./configure --prefix=/usr \
                    --docdir=/usr/share/doc/pcre-$PCRE_VERSION \
                    --enable-unicode-properties \
                    --enable-pcre16 \
                    --enable-pcre32 \
                    --enable-pcregrep-libz \
                    --enable-pcregrep-libbz2 \
                    --enable-pcretest-libreadline \
                    --disable-static && \
        make && make install ; \
        mv -v /usr/lib/libpcre.so.* /lib ; \
        ln -sfv ../../lib/$(readlink /usr/lib/libpcre.so) /usr/lib/libpcre.so ; \
        cd .. ; \
        rm -fr pcre-$PCRE_VERSION ; \
    } && \
    wget --no-verbose "$SWIG_DOWNLOAD_URL" && \
    tar xzf swig-$SWIG_VERSION.tar.gz && \
    rm -f swig-$SWIG_VERSION.tar.gz && \
    { \
        cd swig-$SWIG_VERSION ; \
        ./configure --prefix=/usr --without-clisp --without-maximum-compile-warnings && make && make install ; \
        #install -v -m755 -d /usr/share/doc/swig-$SWIG_VERSION && cp -v -R Doc/* /usr/share/doc/swig-$SWIG_VERSION ; \
        cd .. ; \
        rm -fr swig-$SWIG_VERSION ; \
    }

WORKDIR /

CMD ["swig", "-version"]

