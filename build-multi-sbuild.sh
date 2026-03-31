#!/bin/bash
# Build script for android-sdk-installer using sbuild instead of pbuilder

# Load configuration
source build-multi.config

# Default values if not set in config
DISTRIBUTIONS=${DISTRIBUTIONS:-focal jammy noble}
ARCHES=${ARCHES:-amd64}
BUILDDIR=${BUILDDIR:-output}

# Create build directory
mkdir -p $BUILDDIR

echo "Building source package..."
dpkg-buildpackage -S -sa

# Get the source package name
SOURCE_PACKAGE=$(dpkg-parsechangelog -S Source)
VERSION=$(dpkg-parsechangelog -S Version)
DSC_FILE="../${SOURCE_PACKAGE}_${VERSION}.dsc"

echo "Building for distributions: $DISTRIBUTIONS"
echo "Building for architectures: $ARCHES"

for DIST in $DISTRIBUTIONS; do
    for ARCH in $ARCHES; do
        echo ""
        echo "Building $SOURCE_PACKAGE ($VERSION) for $DIST-$ARCH..."
        
        sbuild \
            --arch=$ARCH \
            --dist=$DIST \
            --build-dir=$BUILDDIR \
            --purge-build=successful \
            --purge-deps=successful \
            $DSC_FILE
            
        if [ $? -eq 0 ]; then
            echo "Build successful for $DIST-$ARCH"
        else
            echo "Build failed for $DIST-$ARCH"
            exit 1
        fi
    done
done

echo ""
echo "All builds completed successfully!"
echo "Built packages are in: $BUILDDIR"
echo ""
echo "To upload to packages.sil.org:"
echo "  dput -U pso:ubuntu/<distribution> $BUILDDIR/*_source.changes  # for each distribution"