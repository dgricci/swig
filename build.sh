#!/bin/bash

## Dockerfile for swig environment

# install compiler environment (See dgricci/build-jessie) :
01-install.sh

# install libpython2.7-dev to prevent fatal error when compiling boost
# link python headers into /usr/include
apt-get -qy install --no-install-recommends \
    libpython2.7-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev
{ \
    cd /usr/include ; \
    find ./python2.7/ -name "*.h" -exec ln -s {} . \; ; \
}

cd /tmp

wget --no-verbose "$WHICH_DOWNLOAD_URL"
tar xzf which-$WHICH_VERSION.tar.gz
rm -f which-$WHICH_VERSION.tar.gz
{ \
    cd which-$WHICH_VERSION ; \
    ./configure --prefix=/usr && make && make install ; \
    cd .. ; \
    rm -fr which-$WHICH_VERSION ; \
}
wget --no-verbose "$BOOST_DOWNLOAD_URL"
tar xzf boost_$BOOST_VERSION.tar.gz
rm -f boost_$BOOST_VERSION.tar.gz
{ \
    cd boost_$BOOST_VERSION ; \
    sed -e '/using python/ s@;@: /usr/include/python${PYTHON_VERSION/3*/${PYTHON_VERSION}m} ;@' -i bootstrap.sh ; \
    sed -e '1 i#ifndef Q_MOC_RUN' -e '$ a#endif' -i boost/type_traits/detail/has_binary_operator.hpp ; \
    ./bootstrap.sh --prefix=/usr && ./b2 stage threading=multi link=shared && ./b2 install threading=multi link=shared ; \
    cd .. ; \
    rm -fr boost_$BOOST_VERSION ; \
}
wget --no-verbose "$PCRE_DOWNLOAD_URL"
tar xzf pcre-$PCRE_VERSION.tar.gz
rm -f pcre-$PCRE_VERSION.tar.gz
# Moves the PCRE library on the root filesystem so that it is available in
# case grep gets reinstalled with PCRE support. 
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
}
wget --no-verbose "$SWIG_DOWNLOAD_URL"
tar xzf swig-$SWIG_VERSION.tar.gz
rm -f swig-$SWIG_VERSION.tar.gz
{ \
    cd swig-$SWIG_VERSION ; \
    ./autogen.sh ; \
    ./configure --prefix=/usr --without-clisp --without-maximum-compile-warnings && make && make install ; \
    #install -v -m755 -d /usr/share/doc/swig-$SWIG_VERSION && cp -v -R Doc/* /usr/share/doc/swig-$SWIG_VERSION ; \
    cd .. ; \
    rm -fr swig-$SWIG_VERSION ; \
}

# uninstall :
apt-get purge -y \
    libpython2.7-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev
01-uninstall.sh y

exit 0

