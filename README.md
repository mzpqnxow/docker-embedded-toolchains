# docker-mipsel-hndtools
Dockerfile for building a container with multiple versions of embedded toolchains including Broadcom hndtools, OpenWRT and MUSL based toolchains

## Notes

Here are various notes that may be relevant

### Acquiring the tarballs

If you want just the toolchain tarballs to set up yourself, you can retrieve some of them from [this](https://github.com/mzpqnxow/hndtools-toolchains) repository. These tarballs are also included here but in some cases may be stripped down, i.e. without the ```src``` directory, for size purposes. The tarballs have also been extracted and recompressed using xz as opposed to bz2 or gz since xz has roughly a 50% size improvement rate on this specific tarballs

### Verifying integrity of the tarballs

Unfortunately, there is no elegant and reliable way to integrity check these files because Broadcom does not release signatures for the hndtools toolchain tarballs or their contents. Trust that I haven't tampered with them, or use only in containers without network access to compile test software? Sorry.
