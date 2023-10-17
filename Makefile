CMOCKAurl = https://cmocka.org/files/1.1/cmocka-1.1.5.tar.xz
MBEDTLSurl = https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/mbedtls-2.16.6.tar.gz
OPENSSLurl = https://www.openssl.org/source/openssl-1.1.1g.tar.gz
SPDMurl = https://github.com/jyao1/openspdm.git
TLSFZZRurl = https://github.com/tlsfuzzer/tlsfuzzer.git

CMOCKAfile = cmocka-1.1.5.tar.xz
MBEDTLSfile = mbedtls-2.16.6.tar.gz
OPENSSLfile = openssl-1.1.1g.tar.gz

SPDMhash = bc1be2b474860c3935e03e5d3444865b8f46760a
TLSFZZRhash = 4e68c41aa029b5303d3acf03050072a0e9be64d5

# SPDM configs:
TOOLCHAIN = GCC
TARGET = Release
CRYPTO = MbedTls
TSTTYPE = OsTest


.PHONY: all

all: cmocka mbedtls openssl openspdm tlsfuzzer

cmocka:
	wget $(CMOCKAurl)
	tar -xvf $(CMOCKAfile)
	mv cmocka-1.1.5 cmocka
	mv cmocka openspdm/UnitTest/CmockaLib

mbedtls:
	wget $(MBEDTLSurl) -O $(MBEDTLSfile)
	tar -xvf $(MBEDTLSfile)
	mv mbedtls-mbedtls-2.16.6 mbedtls
	mv mbedtls openspdm/OsStub/MbedTlsLib

openssl:
	wget $(OPENSSLurl)
	tar -xvf $(OPENSSLfile)
	mv openssl-1.1.1g openssl
	mv openssl openspdm/OsStub/OpensslLib

openspdm:
	git clone $(SPDMurl)
	cd openspdm
	git checkout -b tester $(SPDMhash)
	mkdir build
	cd build
	cmake -DARCH=X64 -DTOOLCHAIN=$(TOOLCHAIN) -DTARGET=$(TARGET) -DCRYPTO=$(CRYPTO) -DTESTTYPE=$(TSTTYPE) ..
	make CopyTestKey
	make
	cd ../..

tlsfuzzer:
	yay -S --noconfirm python-tlslite-ng
	yay -S --noconfirm python-gmpy2
	git clone $(TLSFZZRurl)


clean:
	rm -f $(CMOCKAfile) $(MBEDTLSfile) $(OPENSSLfile)