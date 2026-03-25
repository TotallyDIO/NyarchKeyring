V = $(shell git describe --abbrev=0)
# Do smth to make this work LOL
# Below is for Website/GPG key
FILE_PREFIX = nyarch
# NO idea what below does
PREFIX = /usr/local
# Below is set to TotallyDIO
DEFAULT_KEY = 861A4F44ACF49447

install:
	install -dm755 $(DESTDIR)$(PREFIX)/share/pacman/keyrings/
	install -m0644 ${FILE_PREFIX}{.gpg,-trusted,-revoked} $(DESTDIR)$(PREFIX)/share/pacman/keyrings/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/share/pacman/keyrings/${FILE_PREFIX}{.gpg,-trusted,-revoked}
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/share/pacman/keyrings/
dist:
	git archive --format=tar --prefix=${FILE_PREFIX}-keyring-$(V)/ master | gzip -9 > ${FILE_PREFIX}-keyring-$(V).tar.gz
	gpg --default-key ${DEFAULT_KEY} --detach-sign --use-agent ${FILE_PREFIX}-keyring-$(V).tar.gz

upload:
	rsync --chmod 644 --progress ${FILE_PREFIX}-keyring-$(V).tar.gz ${FILE_PREFIX}-keyring-$(V).tar.gz.sig ${FILE_PREFIX}linux.moe:/nginx/var/www/keyring/
#																			^makes signature										^figure this out lol
.PHONY: install uninstall dist upload

