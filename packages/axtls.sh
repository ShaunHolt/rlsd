PACKAGE_VERSION="1.4.9"
PACKAGE_SOURCES="http://sourceforge.net/projects/axtls/files/$PACKAGE_VERSION/axTLS-$PACKAGE_VERSION.tar.gz"
PACKAGE_DESC="A TLS library"

axtls_build() {
	[ -d axTLS ] && rm -rf axTLS
	tar -xzvf axTLS-$PACKAGE_VERSION.tar.gz
	cd axTLS

	patch -p 1 < "$BASE_DIR/patches/axtls-build.patch"
	
	cat << CONFIG_EOF > config/.config
#
# Automatically generated make config: don't edit
#
HAVE_DOT_CONFIG=y
CONFIG_PLATFORM_LINUX=y
# CONFIG_PLATFORM_CYGWIN is not set
# CONFIG_PLATFORM_WIN32 is not set

#
# General Configuration
#
PREFIX="/"
# CONFIG_DEBUG is not set
# CONFIG_STRIP_UNWANTED_SECTIONS is not set
# CONFIG_VISUAL_STUDIO_7_0 is not set
# CONFIG_VISUAL_STUDIO_8_0 is not set
# CONFIG_VISUAL_STUDIO_10_0 is not set
CONFIG_VISUAL_STUDIO_7_0_BASE=""
CONFIG_VISUAL_STUDIO_8_0_BASE=""
CONFIG_VISUAL_STUDIO_10_0_BASE=""
CONFIG_EXTRA_CFLAGS_OPTIONS="$CFLAGS"
CONFIG_EXTRA_LDFLAGS_OPTIONS="$LDFLAGS -Bstatic"

#
# SSL Library
#
# CONFIG_SSL_SERVER_ONLY is not set
# CONFIG_SSL_CERT_VERIFICATION is not set
# CONFIG_SSL_ENABLE_CLIENT is not set
CONFIG_SSL_FULL_MODE=y
# CONFIG_SSL_SKELETON_MODE is not set
# CONFIG_SSL_PROT_LOW is not set
CONFIG_SSL_PROT_MEDIUM=y
# CONFIG_SSL_PROT_HIGH is not set
CONFIG_SSL_USE_DEFAULT_KEY=y
CONFIG_SSL_PRIVATE_KEY_LOCATION=""
CONFIG_SSL_PRIVATE_KEY_PASSWORD=""
CONFIG_SSL_X509_CERT_LOCATION=""
# CONFIG_SSL_GENERATE_X509_CERT is not set
CONFIG_SSL_X509_COMMON_NAME=""
CONFIG_SSL_X509_ORGANIZATION_NAME=""
CONFIG_SSL_X509_ORGANIZATION_UNIT_NAME=""
CONFIG_SSL_ENABLE_V23_HANDSHAKE=y
CONFIG_SSL_HAS_PEM=y
CONFIG_SSL_USE_PKCS12=y
CONFIG_SSL_EXPIRY_TIME=24
CONFIG_X509_MAX_CA_CERTS=300
CONFIG_SSL_MAX_CERTS=3
# CONFIG_SSL_CTX_MUTEXING is not set
CONFIG_USE_DEV_URANDOM=y
# CONFIG_WIN32_USE_CRYPTO_LIB is not set
CONFIG_OPENSSL_COMPATIBLE=y
# CONFIG_PERFORMANCE_TESTING is not set
# CONFIG_SSL_TEST is not set
CONFIG_AXTLSWRAP=y
# CONFIG_AXHTTPD is not set
# CONFIG_HTTP_STATIC_BUILD is not set
CONFIG_HTTP_PORT=0
CONFIG_HTTP_HTTPS_PORT=0
CONFIG_HTTP_SESSION_CACHE_SIZE=0
CONFIG_HTTP_WEBROOT=""
CONFIG_HTTP_TIMEOUT=0
# CONFIG_HTTP_HAS_CGI is not set
CONFIG_HTTP_CGI_EXTENSIONS=""
# CONFIG_HTTP_ENABLE_LUA is not set
CONFIG_HTTP_LUA_PREFIX=""
# CONFIG_HTTP_BUILD_LUA is not set
CONFIG_HTTP_CGI_LAUNCHER=""
# CONFIG_HTTP_DIRECTORIES is not set
# CONFIG_HTTP_HAS_AUTHORIZATION is not set
# CONFIG_HTTP_HAS_IPV6 is not set
# CONFIG_HTTP_ENABLE_DIFFERENT_USER is not set
CONFIG_HTTP_USER=""
# CONFIG_HTTP_VERBOSE is not set
# CONFIG_HTTP_IS_DAEMON is not set

#
# Language Bindings
#
# CONFIG_BINDINGS is not set
# CONFIG_CSHARP_BINDINGS is not set
# CONFIG_VBNET_BINDINGS is not set
CONFIG_DOT_NET_FRAMEWORK_BASE=""
# CONFIG_JAVA_BINDINGS is not set
CONFIG_JAVA_HOME=""
# CONFIG_PERL_BINDINGS is not set
CONFIG_PERL_CORE=""
CONFIG_PERL_LIB=""
# CONFIG_LUA_BINDINGS is not set
CONFIG_LUA_CORE=""

#
# Samples
#
# CONFIG_SAMPLES is not set
# CONFIG_C_SAMPLES is not set
# CONFIG_CSHARP_SAMPLES is not set
# CONFIG_VBNET_SAMPLES is not set
# CONFIG_JAVA_SAMPLES is not set
# CONFIG_PERL_SAMPLES is not set
# CONFIG_LUA_SAMPLES is not set

#
# BigInt Options
#
# CONFIG_BIGINT_CLASSICAL is not set
# CONFIG_BIGINT_MONTGOMERY is not set
CONFIG_BIGINT_BARRETT=y
CONFIG_BIGINT_CRT=y
# CONFIG_BIGINT_KARATSUBA is not set
MUL_KARATSUBA_THRESH=0
SQU_KARATSUBA_THRESH=0
CONFIG_BIGINT_SLIDING_WINDOW=y
CONFIG_BIGINT_SQUARE=y
# CONFIG_BIGINT_CHECK_ON is not set
CONFIG_INTEGER_32BIT=y
# CONFIG_INTEGER_16BIT is not set
# CONFIG_INTEGER_8BIT is not set
CONFIG_EOF

	yes "" | $MAKE config

	cd ssl
	mkdir ../_stage
	$MAKE .././_stage/libaxtls.a
}

axtls_package() {
	cd ..
	install -D -m 644 _stage/libaxtls.a "$1/lib/libaxtls.a"
	ln -s libaxtls.a "$1/lib/libssl.a"
	ln -s libaxtls.a "$1/lib/libcrypto.a"

	for i in crypto/*.h ssl/*.h config/config.h
	do
		install -D -m 644 $i "$1/usr/include/axTLS/$(basename $i)"
	done
	ln -s axTLS "$1/usr/include/openssl"

	install -D -m 644 README "$1/usr/share/doc/axTLS/README"
	install -m 644 www/index.html "$1/usr/share/doc/axTLS/index.html"
}
