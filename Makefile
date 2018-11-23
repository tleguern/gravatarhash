PROG= gravatarhash
SRCS= gravatarhash.sh

.SUFFIXES: .sh

.sh:
	cp $< $@
	chmod +x $@

gravatarhash: gravatarhash.sh
