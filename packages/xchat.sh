PACKAGE_VERSION="git$(date +%d%m%Y)"
PACKAGE_SOURCES="https://github.com/dimkr/xchat/archive/master.zip,xchat-$PACKAGE_VERSION.zip"
PACKAGE_DESC="An IRC client"

build() {
	[ -d xchat-master ] && rm -rf xchat-master
	unzip xchat-$PACKAGE_VERSION.zip
	cd xchat-master

	patch -p 1 < "$BASE_DIR/patches/xchat-font.patch"
	patch -p 1 < "$BASE_DIR/patches/xchat-settings.patch"
	./configure --host=$HOST \
	            --prefix= \
	            --datadir=/usr/share \
	            --disable-nls \
	            --enable-openssl \
	            --enable-ipv6 \
	            --disable-textfe \
	            --disable-perl \
	            --disable-plugin
	$MAKE
}

package() {
	$MAKE DESTDIR="$1" install
	install -D -m 644 README "$1/usr/share/doc/xchat/README"
	install -m 644 FAQ "$1/usr/share/doc/xchat/FAQ"
	install -m 644 AUTHORS "$1/usr/share/doc/xchat/AUTHORS"
	install -m 644 COPYING "$1/usr/share/doc/xchat/COPYING"
}
