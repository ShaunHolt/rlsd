PACKAGE_VERSION="0.9.14"
PACKAGE_SOURCES="http://www.musl-libc.org/releases/musl-$PACKAGE_VERSION.tar.gz"

musl_build() {
	[ -d musl-$PACKAGE_VERSION ] && rm -rf musl-$PACKAGE_VERSION
	tar -xzvf musl-$PACKAGE_VERSION.tar.gz
	cd musl-$PACKAGE_VERSION

	./configure --prefix=$SYSROOT \
	            --includedir=$SYSROOT/usr/include \
	            --disable-debug \
	            --enable-gcc-wrapper \
	            $CONFIGURE_LIBRARY_FLAGS
	make
}

musl_package() {
	# TODO: figure out how to build the GCC wrapper without having an empty
	# installation directory
	make install

	install -D -m 644 README "$1/usr/share/doc/musl/README"
	install -D -m 644 WHATSNEW "$1/usr/share/doc/musl/WHATSNEW"
	install -D -m 644 COPYRIGHT "$1/usr/share/doc/musl/COPYRIGHT"
}