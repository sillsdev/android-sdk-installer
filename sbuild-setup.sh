#!/bin/bash
# Setup script for switching from pbuilder to sbuild

# Install sbuild
sudo apt-get install sbuild schroot debootstrap

# Add your user to sbuild group
sudo adduser $USER sbuild

# Create build chroots for your target distributions
DISTRIBUTIONS=${DISTRIBUTIONS:-focal jammy noble}
ARCHES=${ARCHES:-amd64}

for DIST in $DISTRIBUTIONS; do
    for ARCH in $ARCHES; do
        echo "Creating chroot for $DIST-$ARCH..."
        sudo sbuild-createchroot \
            --include=eatmydata,ccache,gnupg \
            $DIST \
            /srv/chroot/$DIST-$ARCH-sbuild \
            http://archive.ubuntu.com/ubuntu/
    done
done

echo "Setup complete! You may need to log out and back in for group changes to take effect."
