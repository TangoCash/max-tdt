bin_PROGRAMS = fbshot

fbshot_SOURCES = fbshot.c

fbshot_LDADD = -lpng -lz

man_MANS = fbshot.1

install-exec-local:
	install -d $(DESTDIR)/var/bin
	install -m 0755 $(srcdir)/fbshot $(DESTDIR)/var/bin
