PACKAGE_VERSION="2.5.0"
PACKAGE_SOURCES="http://sourceforge.net/projects/prboom/files/prboom%20stable/2.5.0/prboom-2.5.0.tar.gz"
PACKAGE_DESC="A first-person shooter"

build() {
	[ -d prboom-$PACKAGE_VERSION ] && rm -rf prboom-$PACKAGE_VERSION
	tar -xzvf prboom-$PACKAGE_VERSION.tar.gz
	cd prboom-$PACKAGE_VERSION

	patch -p 1 < "$BASE_DIR/patches/prboom-build.patch"
	patch -p 1 < "$BASE_DIR/patches/prboom-libpng.patch"
	patch -p 1 < "$BASE_DIR/patches/prboom-settings.patch"
	patch -p 1 < "$BASE_DIR/patches/prboom-doc.patch"

	LIBS="-lasound $(pkg-config --libs libpng SDL_mixer)" \
	./configure --host=$HOST \
	            --prefix=/usr \
	            --bindir=/bin \
	            --datarootdir=/usr/share \
	            --disable-debug \
	            --disable-gl \
	            --with-waddir=/usr/share/doom
	$MAKE
}

package() {
	$MAKE DESTDIR="$1" install
}
