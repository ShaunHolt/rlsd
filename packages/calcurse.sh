PACKAGE_VERSION="3.2.1"
PACKAGE_SOURCES="http://calcurse.org/files/calcurse-$PACKAGE_VERSION.tar.gz"
PACKAGE_DESC="A personal organizer"

build() {
	[ -d calcurse-$PACKAGE_VERSION ] && rm -rf calcurse-$PACKAGE_VERSION
	tar -xzvf calcurse-$PACKAGE_VERSION.tar.gz
	cd calcurse-$PACKAGE_VERSION

	patch -p 1 < "$BASE_DIR/patches/calcurse-doc.patch"

	./configure --host=$HOST \
	            --prefix= \
	            --datarootdir=/usr/share \
	            --disable-nls \
	            --disable-memory-debug
	$MAKE
}

package() {
	$MAKE DESTDIR="$1" install
	install -D -m 644 README "$1/usr/share/doc/calcurse/README"
	install -D -m 644 NEWS "$1/usr/share/doc/calcurse/NEWS"
	install -D -m 644 AUTHORS "$1/usr/share/doc/calcurse/AUTHORS"
	install -D -m 644 COPYING "$1/usr/share/doc/calcurse/COPYING"
}
