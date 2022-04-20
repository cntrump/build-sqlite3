#!/usr/bin/env bash

set -eux

sqlite_src=sqlite-autoconf-3380200

if [ ! -d ${sqlite_src} ]; then
  tar xvf ${sqlite_src}.tar.xz
fi

pushd ${sqlite_src}

features=(
    "-DSQLITE_THREADSAFE=1"
    "-DSQLITE_ENABLE_EXPLAIN_COMMENTS"
    "-DSQLITE_HAVE_ZLIB"
    "-DSQLITE_INTROSPECTION_PRAGMAS"
    "-DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION"
    "-DSQLITE_ENABLE_STMTVTAB"
    "-DSQLITE_ENABLE_DBPAGE_VTAB"
    "-DSQLITE_ENABLE_DBSTAT_VTAB"
    "-DSQLITE_ENABLE_OFFSET_SQL_FUNC"
    "-DSQLITE_ENABLE_JSON1"
    "-DSQLITE_ENABLE_RTREE"
    "-DSQLITE_ENABLE_FTS4"
    "-DSQLITE_ENABLE_FTS5"
)

CC=clang \
CFLAGS="-target apple-macosx10.9 -arch arm64 -arch x86_64 ${features[*]}" \
./configure --prefix=/opt/local \
            --enable-static-shell \
            --enable-editline \
            --enable-readline

make -j
sudo make install

popd
