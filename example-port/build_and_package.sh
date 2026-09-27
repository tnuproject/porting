#!/bin/sh
set -e

echo "==> Building hello-tiramisu..."
make clean
make

echo "==> Staging installation into ./stage..."
make install DESTDIR=./stage PREFIX=/usr/local

echo "==> Packaging with tiramisu-pkg-create..."
python3 ../tiramisu-pkg-create \
    --name hello-tiramisu \
    --version 1.0.0 \
    --origin misc/hello-tiramisu \
    --comment "Example Hello World port for Tiramisu OS" \
    --stage-dir ./stage \
    --out ./hello-tiramisu-1.0.0.pkg

echo "==> Done! Generated ./hello-tiramisu-1.0.0.pkg"
