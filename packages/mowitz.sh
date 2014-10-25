PACKAGE_VERSION="0.3.1"
PACKAGE_SOURCES="http://siag.nu/pub/mowitz/Mowitz-$PACKAGE_VERSION.tar.gz"
PACKAGE_DESC="An extra GUI widgets library"

build() {
	[ -d Mowitz-$PACKAGE_VERSION ] && rm -rf siag-$PACKAGE_VERSION
	tar -xzvf Mowitz-$PACKAGE_VERSION.tar.gz
	cd Mowitz-$PACKAGE_VERSION

	patch -p 1 < "$BASE_DIR/patches/mowitz-build.patch"
	patch -p 1 < "$BASE_DIR/patches/mowitz-tinyxlib.patch"

	make clean
	./configure --host=$HOST \
	            --prefix= \
	            --includedir=/usr/include \
	            --datadir=/usr/share \
	            $CONFIGURE_LIBRARY_FLAGS \
	            --with-xaw3d=Xaw
	$MAKE
}

package() {
	$MAKE DESTDIR="$1" install
	install -D -m 644 README "$1/usr/share/doc/mowitz/README"
	install -m 644 ChangeLog "$1/usr/share/doc/mowitz/ChangeLog"
	install -m 644 NEWS "$1/usr/share/doc/mowitz/NEWS"
	install -m 644 AUTHORS "$1/usr/share/doc/mowitz/AUTHORS"
	install -m 644 COPYING "$1/usr/share/doc/mowitz/COPYING"
}
