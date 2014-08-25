SCRIPT= gravatarhash.sh
MAN= gravatarhash.1

BINDIR?= bin
DESTDIR?= /usr/local/

install:
	${INSTALL} ${INSTALL_COPY} -o ${BINOWN} -g ${BINGRP} -m ${BINMODE} \
		${.CURDIR}/${SCRIPT} ${DESTDIR}${BINDIR}/gravatarhash

.include <bsd.prog.mk>
