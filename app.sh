### ZLIB ###
_build_zlib() {
local VERSION="1.2.8"
local FOLDER="zlib-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://zlib.net/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --prefix="${DEPS}" --libdir="${DEST}/lib"
make
make install
rm -v "${DEST}/lib/libz.a"
popd
}

### BZIP ###
_build_bzip() {
local VERSION="1.0.6"
local FOLDER="bzip2-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://bzip.org/1.0.6/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd target/"${FOLDER}"
sed -i -e "s/all: libbz2.a bzip2 bzip2recover test/all: libbz2.a bzip2 bzip2recover/" Makefile
make -f Makefile-libbz2_so CC="${CC}" AR="${AR}" RANLIB="${RANLIB}" CFLAGS="${CFLAGS} -fpic -fPIC -Wall -D_FILE_OFFSET_BITS=64"
ln -s libbz2.so.1.0.6 libbz2.so
cp -vfaR *.h "${DEPS}/include/"
cp -vfaR *.so* "${DEST}/lib/"
popd
}

### LIBLZMA ###
_build_liblzma() {
local VERSION="5.2.0"
local FOLDER="xz-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://tukaani.org/xz/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" --libdir="${DEST}/lib" --disable-static --disable-{xz,xzdec,lzmadec,lzmainfo,lzma-links,scripts,docs}
make
make install
popd
}

### LIBJPEG ###
_build_libjpeg() {
local VERSION="9a"
local FOLDER="jpeg-${VERSION}"
local FILE="jpegsrc.v${VERSION}.tar.gz"
local URL="http://www.ijg.org/files/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" --libdir="${DEST}/lib" --disable-static --enable-maxmem=8
make
make install
popd
}

### LIBPNG ###
_build_libpng() {
local VERSION="1.6.16"
local FOLDER="libpng-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://sourceforge.net/projects/libpng/files/libpng16/${VERSION}/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" --libdir="${DEST}/lib" --disable-static
make
make install
popd
}

### LIBTIFF ###
_build_libtiff() {
local VERSION="4.0.3"
local FOLDER="tiff-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="ftp://ftp.remotesensing.org/pub/libtiff/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" --libdir="${DEST}/lib" --disable-static --enable-rpath
make
make install
popd
}

### IMAGEMAGICK ###
_build_imagemagick() {
local VERSION="6.9.0-7"
local FOLDER="ImageMagick-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://sourceforge.net/projects/imagemagick/files/6.9.0-sources/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
PKG_CONFIG_PATH="${DEST}/lib/pkgconfig" ./configure --host="${HOST}" --prefix="${DEST}" --disable-static
make
make install
popd
}

_build() {
  _build_zlib
  _build_bzip
  _build_liblzma
  _build_libjpeg
  _build_libpng
  _build_libtiff
  _build_imagemagick
  _package
}
