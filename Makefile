SCMVERSION := $(shell git describe --tags --dirty=+ --always 2>/dev/null || \
		echo "UNKNOWN")
SCMBRANCH := $(shell (git branch 2> /dev/null || echo '* UNKNOWN') | \
		awk '/^\* / {print $$2;}')

BUILDDIR ?= buildresults

DESTDIR ?= /usr/bin


$(BUILDDIR)/bart : bart
	@[ -d "$(@D)" ] || mkdir -p "$(@D)"
	sed -e "s/\(BARTVERSION=\).*/\1$(SCMVERSION)/" $< > $@
	chmod +x $@


SUDO := $(shell [ -w $(DESTDIR) ] || echo sudo)
.PHONY : install
install : $(BUILDDIR)/bart
	$(SUDO) cp -v $< $(DESTDIR)/


.PHONY : clean
clean :
	rm -rf $(BUILDDIR)
