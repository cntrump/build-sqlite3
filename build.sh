#!/usr/bin/env bash

set -eux

sqlite_src=sqlite-autoconf-3380200

[ -d ${sqlite_src} ] && rm -rf ${sqlite_src}

tar xvf ${sqlite_src}.tar.xz

pushd ${sqlite_src}

threading_mode=2
sed -i -e "s/-DSQLITE_THREADSAFE=1/-DSQLITE_THREADSAFE=${threading_mode}/g" ./configure

features=(
    "-DSQLITE_INTROSPECTION_PRAGMAS"
    "-DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION"
    "-DSQLITE_ENABLE_OFFSET_SQL_FUNC"
    "-DSQLITE_ENABLE_JSON1"
)

CC=clang \
CFLAGS="-target apple-macosx10.9 -arch arm64 -arch x86_64 ${features[*]}" \
./configure --prefix="$(pwd)/../local" \
            --enable-static-shell \
            --enable-editline \
            --enable-readline \
            --enable-threadsafe

make -j
sudo make install

popd

pushd "local"
tar --uid 0 --gid 0 -cJvf ../sqlite3.tar.xz $(ls)
popd
