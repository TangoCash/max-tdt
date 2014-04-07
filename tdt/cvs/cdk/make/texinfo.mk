#
# build own duckbox-cdk texinfo
#
$(DEPDIR)/texinfo.do_prepare: @DEPENDS_texinfo@
	@PREPARE_texinfo@
	touch $@

$(DEPDIR)/texinfo.do_compile: $(DEPDIR)/texinfo.do_prepare
	cd @DIR_texinfo@ && \
		./configure \
			--build=$(build) \
			--host=$(build) \
			--prefix= && \
			$(MAKE) all && \
			$(MAKE) install DESTDIR=$(hostprefix)
	touch $@

$(DEPDIR)/texinfo: \
$(DEPDIR)/%texinfo: $(DEPDIR)/texinfo.do_compile
	cd @DIR_texinfo@ && \
		@INSTALL_texinfo@
	@DISTCLEANUP_texinfo@
	[ "x$*" = "x" ] && touch $@ || true
