PACKAGE_VERSION="1.6.5"
PACKAGE_SOURCES="http://ftp.nluug.nl/pub/os/Linux/distr/amigolinux/download/Applications/Misc/gtkdiskfree-$PACKAGE_VERSION/gtkdiskfree-$PACKAGE_VERSION.tar.bz2"
PACKAGE_DESC="A disk usage analyzer"

build() {
	[ -d gtkdiskfree-$PACKAGE_VERSION ] && rm -rf gtkdiskfree-$PACKAGE_VERSION
	tar -xjvf gtkdiskfree-$PACKAGE_VERSION.tar.bz2
	cd gtkdiskfree-$PACKAGE_VERSION

	patch -p 1 < "$BASE_DIR/patches/gtkdiskfree-build.patch"
	patch -p 1 < "$BASE_DIR/patches/gtkdiskfree-setmntent.patch"

	./configure --host=$HOST --prefix= --datadir=/usr/share --disable-nls
	$MAKE
}

package() {
	$MAKE DESTDIR="$1" install
	install -D -m 644 README "$1/usr/share/doc/gtkdiskfree/README"
	install -m 644 NEWS "$1/usr/share/doc/gtkdiskfree/NEWS"
	install -m 644 ChangeLog "$1/usr/share/doc/gtkdiskfree/ChangeLog"
	install -m 644 AUTHORS "$1/usr/share/doc/gtkdiskfree/AUTHORS"
	install -m 644 THANKS "$1/usr/share/doc/gtkdiskfree/THANKS"
	install -m 644 COPYING "$1/usr/share/doc/gtkdiskfree/COPYING"
}
