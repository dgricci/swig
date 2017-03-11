## Dockerfile for swig environment
FROM dgricci/build-jessie:0.0.4
MAINTAINER Didier Richard <didier.richard@ign.fr>

## different versions - use argument when defined otherwise use defaults
# See http://www.linuxfromscratch.org/blfs/view/cvs/general/swig.html
ARG WHICH_VERSION
ENV WHICH_VERSION ${WHICH_VERSION:-2.21}
ARG WHICH_DOWNLOAD_URL
ENV WHICH_DOWNLOAD_URL ${WHICH_DOWNLOAD_URL:-https://ftp.gnu.org/gnu/which/which-$WHICH_VERSION.tar.gz}
ARG BOOST_VERSION
ENV BOOST_VERSION ${BOOST_VERSION:-1_63_0}
ARG BOOST_DOWNLOAD_URL
ENV BOOST_DOWNLOAD_URL ${BOOST_DOWNLOAD_URL:-https://downloads.sourceforge.net/boost/boost_$BOOST_VERSION.tar.gz}
ARG PCRE_VERSION
ENV PCRE_VERSION ${PCRE_VERSION:-8.40}
ARG PCRE_DOWNLOAD_URL
ENV PCRE_DOWNLOAD_URL ${PCRE_DOWNLOAD_URL:-https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$PCRE_VERSION.tar.gz}
ARG SWIG_VERSION
ENV SWIG_VERSION ${SWIG_VERSION:-3.0.12}
ARG SWIG_DOWNLOAD_URL
ENV SWIG_DOWNLOAD_URL ${SWIG_DOWNLOAD_URL:-https://downloads.sourceforge.net/swig/swig-$SWIG_VERSION.tar.gz}

COPY build.sh /tmp/build.sh

RUN /tmp/build.sh && rm -f /tmp/build.sh

WORKDIR /

CMD ["swig", "-version"]

