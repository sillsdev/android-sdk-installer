# android-sdk-installer

Debian package to download and install the Android SDK.

The default behavior is to download the required files from Google's Android software repository via HTTP during the install.  You can download the files prior to installing the package and then provide them to the package at install time with the following instructions.

Download the Android SDK files:
* On a network connected computer, download 4 zip files (around 400 MB). [Note: The -c option will allow the downloads to be resumed if it fails part way through the download.]
```bash
mkdir -p ~/Downloads/android-sdk-zips
cd ~/Downloads/android-sdk-zips
wget -ci http://bit.ly/android-sdk-urls
```
Later, when you want to install:
* [Setting up Linux Repositories to download SIL Software](https://docs.google.com/document/d/1ARhH2buhP-sgyoagkeR1M8DmraOrtfiwO5Z15ny1QiY/edit?usp=sharing) (if you are using [Wasta Linux](https://sites.google.com/site/wastalinux/), then this is already done)
* Use debconf to preseed the package with the location of the files and install the package.
```bash
echo android-sdk-installer android-sdk-installer/dldir string ~/Downloads/android-sdk-zips | sudo debconf-set-selections
sudo apt-get install android-sdk-installer
echo android-sdk-installer android-sdk-installer/dldir string | sudo debconf-set-selections
```
## Building the Debian Package

* debuild -i -us -uc -S
* pbuilder
