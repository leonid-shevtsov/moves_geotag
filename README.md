# Geotag photos using Moves.app

Shell script to geotag photos from your GPS-less camera using the track automatically logged by the [Moves app](http://moves-app.com) for iOS and Android.

The Moves app logs all your movements automatically, 24/7. This script is built on the premise that wherever you make photos, you also have your phone with you, and the movement track from your phone matches the positions of your photos. For me personally, this is much simpler than running a gps tracker specifically at shooting time (because it's often spontaneous.)

## Installation

You need to be using [Moves](http://moves-app.com) and authorize the third-party [Moves Export web app](http://www.moves-export.com) using your Moves account. (Check it out, it has many cool features besides track export.)

You'll need [exiftool](http://www.sno.phy.queensu.ca/~phil/exiftool/) and [jq](https://stedolan.github.io/jq/). On Mac, they are available from [Homebrew](http://brew.sh):

```shell
brew install exiftool jq 
```

Then obtain `moves_geotag.sh` from this repo. (Oh, you'll also need Bash. But hey - in our time it's even shipped with Windows 10!)

## Usage

1. Optionally mount your SD card.

2. Run the script:
    ```shell
    ./moves_geotag.sh /path/to/your/photos
    ```

3. It'll prompt you to download a track file for each of the days you have been shooting at. All non-geotagged photos in the directory are inspected.

4. Once you've downloaded the tracks, hit ENTER and your photos will be geotagged.

5. Done. Now you can import the photos into your photo management solution.

* * * 

Made by [Leonid Shevtsov](https://leonid.shevtsov.me)
