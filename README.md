# android-sdk-installer

Debian package to download install the Android SDK.

The default behavior is to download the required files from Google's Android software repository via HTTP.  You can download the files separately and then provide them to the installer package. Do the following:

* On a network connected computer, download 4 zip files (around 400 MB). 
```bash
wget -i http://bit.ly/android-sdk-urls
```
* Later, when you want to install:
* [Setting up Linux Repositories to download SIL Software](https://docs.google.com/document/d/1ARhH2buhP-sgyoagkeR1M8DmraOrtfiwO5Z15ny1QiY/edit?usp=sharing) (if you are using [Wasta Linux](https://sites.google.com/site/wastalinux/), then this is already done)
* Use debconf to preseed the installer and run the installer
```bash
echo android-sdk-installer android-sdk-installer/dldir string path/to/downloaded/zipfiles | sudo debconf-set-selections
sudo apt-get install android-sdk-installer
```
