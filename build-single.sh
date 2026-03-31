#!/bin/bash
# Simple build script - builds once since package is now distribution-agnostic

# Load configuration for architecture settings
source build-multi.config 2>/dev/null || true

ARCH=${ARCHES:-amd64}
DIST=${DIST:-jammy}  # Default to jammy, but could be any of focal/jammy/noble
BUILDDIR=${BUILDDIR:-output}

echo "Building distribution-agnostic package..."
echo "Using $DIST chroot for build environment"

# Create output directory
mkdir -p $BUILDDIR

# Build source package
dpkg-buildpackage -S -sa

# Get the source package details
SOURCE_PACKAGE=$(dpkg-parsechangelog -S Source)
VERSION=$(dpkg-parsechangelog -S Version)
DSC_FILE="../${SOURCE_PACKAGE}_${VERSION}.dsc"

# Build binary package (using any distribution since result is identical)
sbuild \
    --arch=$ARCH \
    --dist=$DIST \
    --build-dir=$BUILDDIR \
    --purge-build=successful \
    --purge-deps=successful \
    $DSC_FILE

if [ $? -eq 0 ]; then
    echo ""
    echo "Build successful!"
    echo "Package built: $BUILDDIR"
    echo ""
    echo "Since the package is now distribution-agnostic, you can upload"
    echo "this single build to multiple distribution repositories:"
    echo ""
    echo "  dput -U pso:ubuntu/focal $BUILDDIR/*_source.changes"
    echo "  dput -U pso:ubuntu/jammy $BUILDDIR/*_source.changes"  
    echo "  dput -U pso:ubuntu/noble $BUILDDIR/*_source.changes"
else
    echo "Build failed!"
    exit 1
fi