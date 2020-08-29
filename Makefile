# $FreeBSD$

PORTNAME=	feh-ucspi-ssl
DISTVERSION=	0.11.4
PORTREVISION=	2
CATEGORIES=	sysutils net
DISTNAME=	ucspi-ssl-${DISTVERSION}
MASTER_SITES=	https://www.fehcom.de/ipnet/ucspi-ssl/
EXTRACT_SUFX=   .tgz

BUILD_DEPENDS=	fehQlibs>=14:sysutils/fehQlibs

WRKSRC=		${WRKDIR}/host/superscript.com/net/${DISTNAME}

MAINTAINER=	dl-ports@perfec.to
COMMENT=	Command line tools for building SSL client-server applications
LICENSE=	PD
LICENSE_FILE=	${FILESDIR}/LICENSE

PROGRAMS=	sslclient \
		sslhandle \
		sslprint \
		sslserver

SCRIPTS=	https@ \
		sslcat \
		sslconnect

MAN1=		https@.1 \
		sslcat.1 \
		sslclient.1 \
		sslconnect.1 \
		sslhandle.1 \
		sslserver.1

MAN2=		ucspi-tls.2

SAMPLE_CONFIGS=	127.0.0.1.key \
		127.0.0.1.pem \
		127.0.0.1.pw \
		::1.key \
		::1.pem \
		::1.pw \
		chain4.pem \
		chain6.pem \
		dh1024.pem \
		localhost.key \
		localhost.pem \
		localhost.pw \
		openssl.cnf \
		rootCA.pem

do-configure:
	${ECHO_CMD} '${ETCDIR}' > ${WRKSRC}/conf-cadir
	${ECHO_CMD} '${CC} -I${PREFIX}/include ${CFLAGS}' > ${WRKSRC}/conf-cc
	${ECHO_CMD} '${ETCDIR}/dh1024.pem' > ${WRKSRC}/conf-dhfile
	${ECHO_CMD} '${PREFIX}' > ${WRKSRC}/conf-home
	${ECHO_CMD} '${CC} -s' > ${WRKSRC}/conf-ld
	#${ECHO_CMD} '${PREFIX}/man' > ${WRKSRC}/conf-man
	${ECHO_CMD} '${PREFIX}/lib' > ${WRKSRC}/conf-qlibs

do-build:
	cd ${WRKSRC} && package/compile base

do-install:
.for file_name in ${PROGRAMS}
	${INSTALL_PROGRAM} ${WRKSRC}/compile/${file_name} ${STAGEDIR}${PREFIX}/bin
.endfor
.for file_name in ${SCRIPTS}
	${INSTALL_SCRIPT} ${WRKSRC}/compile/${file_name} ${STAGEDIR}${PREFIX}/bin
.endfor
	${INSTALL_DATA} ${WRKSRC}/compile/ucspissl.a ${STAGEDIR}${PREFIX}/lib
	${INSTALL_DATA} ${WRKSRC}/compile/ssl.lib ${STAGEDIR}${PREFIX}/lib
	${INSTALL_DATA} ${WRKSRC}/compile/ucspissl.h ${STAGEDIR}${PREFIX}/include
	${INSTALL_DATA} ${WRKSRC}/conf-ssl ${STAGEDIR}${PREFIX}/lib/conf-ssl
.for file_name in ${MAN1}
	${INSTALL_MAN} ${WRKSRC}/man/${file_name} ${STAGEDIR}${MAN1PREFIX}/man1
.endfor
.for file_name in ${MAN2}
	${INSTALL_MAN} ${WRKSRC}/man/${file_name} ${STAGEDIR}${MAN2PREFIX}/man2
.endfor
	${MKDIR} ${STAGEDIR}${ETCDIR}
.for file_name in ${SAMPLE_CONFIGS}
	${INSTALL_DATA} ${WRKSRC}/etc/${file_name} ${STAGEDIR}${ETCDIR}/${file_name}.sample
.endfor

.include <bsd.port.mk>
