SCMVERSION := $(shell git describe --tags --dirty=+ --always 2>/dev/null || \
		echo "UNKNOWN")

BUILDDIR ?= buildresults

DESTDIR ?= /usr/bin

.PHONY: all
all : $(BUILDDIR)/bart $(BUILDDIR)/bartbot

$(BUILDDIR)/bart : bart
	@[ -d "$(@D)" ] || mkdir -p "$(@D)"
	sed -e "s/\(BARTVERSION=\).*/\1$(SCMVERSION)/" $< > $@
	chmod +x $@

$(BUILDDIR)/bartbot : bartbot
	@[ -d "$(@D)" ] || mkdir -p "$(@D)"
	sed -e "s/\(BARTVERSION=\).*/\1$(SCMVERSION)/" $< > $@
	chmod +x $@


SUDO := $(shell [ -w $(DESTDIR) ] || echo sudo)
.PHONY : install
install : $(BUILDDIR)/bart $(BUILDDIR)/bartbot
	$(SUDO) cp -v $^ $(DESTDIR)/


.PHONY : clean
clean :
	rm -rf $(BUILDDIR)
