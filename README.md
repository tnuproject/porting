# Tiramisu Porting & Packaging Toolchain

This repository provides tools, templates, and specifications for third-party developers to port software to **Tiramisu OS**, generate standard `.pkg` binary packages, and create custom package repositories compatible with Tiramisu's `pkg` utility.

---

## Repository Contents

- **`tiramisu-pkg-create`**: Command-line utility to package a staged build directory into a compliant `.pkg` archive with `+MANIFEST` and SHA-256 metadata.
- **`tiramisu-repo-create`**: Utility to scan a directory of packages, extract manifests, calculate hashes, verify dependency closure, and build `repo.json` for repository hosting.
- **`Portfile.template`**: Standard template for defining port build rules and dependencies.
- **`example-port/`**: A fully functional example project demonstrating end-to-end building and packaging.

---

## Quick Start: Packaging Software

### 1. Build and Stage Your Software

Compile your software targeting x86_64 FreeBSD 14 / Tiramisu ABI, and stage the files into a staging directory (e.g. `./stage`):

```bash
make
make install DESTDIR=./stage PREFIX=/usr/local
```

### 2. Generate the `.pkg` Archive

Run `tiramisu-pkg-create`:

```bash
python3 tiramisu-pkg-create \
    --name myapp \
    --version 1.0.0 \
    --origin sysutils/myapp \
    --comment "High performance system monitor for Tiramisu" \
    --stage-dir ./stage \
    --deps ncurses,coreutils \
    --out myapp-1.0.0.pkg
```

This will automatically:
- Inspect all files and detect ELF64 binaries.
- Generate standard `+MANIFEST` JSON metadata.
- Pack into standard `ustar` archive format.
- Output file size and SHA-256 cryptographic checksum.

---

## Hosting Your Own Package Repository

Tiramisu's package manager (`pkg`) can connect to any HTTP/HTTPS server or GitHub raw content repository.

### 1. Organize Your Packages

Place all your `.pkg` files in a `packages/` directory:

```
my-repo/
├── packages/
│   ├── myapp-1.0.0.pkg
│   └── otherapp-2.1.0.pkg
└── repo.json (generated in next step)
```

### 2. Generate `repo.json`

Run `tiramisu-repo-create`:

```bash
python3 tiramisu-repo-create \
    --name my-repo \
    --url "https://raw.githubusercontent.com/username/my-repo/main" \
    --packages-dir ./packages \
    --out ./repo.json \
    --description "Community software repository for Tiramisu OS"
```

### 3. Publish to GitHub or Web Server

Commit and push `packages/` and `repo.json` to your GitHub repository (or upload to an Nginx / Apache / S3 bucket).

### 4. Add Repository on Tiramisu OS

On your Tiramisu OS machine:

```bash
# Add your repository
pkg repo add my-repo https://raw.githubusercontent.com/username/my-repo/main

# Update repository catalog
pkg update

# Search and install your package
pkg search myapp
pkg install myapp
```

---

## Package Specification (`+MANIFEST`)

Every `.pkg` file is a `tar` archive containing `+MANIFEST` as its first entry:

```json
{
  "name": "myapp",
  "version": "1.0.0",
  "origin": "sysutils/myapp",
  "comment": "High performance system monitor for Tiramisu",
  "desc": "myapp version 1.0.0 packaged for Tiramisu OS.",
  "maintainer": "ports@tiramisu.org",
  "www": "https://github.com/example/myapp",
  "prefix": "/usr/local",
  "deps": ["ncurses", "coreutils"],
  "files": [
    "usr/local/bin/myapp",
    "usr/local/share/man/man1/myapp.1"
  ],
  "abi": "FreeBSD:14:amd64"
}
```

---

## License

This toolchain is licensed under the BSD 2-Clause License. See the Tiramisu Project documentation for details.
