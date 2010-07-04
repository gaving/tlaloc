# Tlaloc

This application aims to be a native, cocoa-based mac application for
interacting with rtorrent via the exposed xmlrpc interface.

## Installation

- Configure rtorrent to actually use xmlrpc (see the official guide [here][1])
- Check out the downloads page and grab the latest build of tlaloc
- Open the preferences panel and enter your rtorrent RPC URI (e.g. http://192.168.1.100/RPC2)

And optionally..

- Fill out the accessible destination path (this isn't strictly necessary, and
assumes you can reach the download directory from the machine running tlaloc)
if you want launching to work, double clicking to open the files, quickly
opening the destination folder, etc.

[1]: http://libtorrent.rakshasa.no/wiki/RTorrentXMLRPCGuide "here"

## Screenshots

![main window!](http://github.com/gaving/tlaloc/raw/master/site/1.png)

## Download

Check out the [releases page](http://github.com/gaving/tlaloc/downloads) on
github for the latest release.
