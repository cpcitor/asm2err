mydefault: auto_setup_cdtc
	$(MAKE) runme

runme: $(CDTC_ENV_FOR_CPCEC) runme.dsk
	$(MAKE) $(CDTC_ENV_FOR_CPCEC) # hack, shouldn't be needed
	( source $(CDTC_ENV_FOR_CPCEC) ; \
	cpcec -m2 runme.dsk ; )

runme.dsk: err.bas errcatch.bas dsk $(CDTC_ENV_FOR_CPCXFS)
	( source $(CDTC_ENV_FOR_CPCXFS) ; \
	set -eu ; \
	cp asm2err.dsk $@.tmp ; \
	cpcxfs $@.tmp -f -t -p err.bas ; \
	cpcxfs $@.tmp -f -t -p errcatch.bas ; \
	mv -vf $@.tmp $@ ; \
	)
