#!/bin/bash

DOWNLOADS_PATH=${2:-$HOME/Downloads}
PHOTO_PATH=$1

if [[ -z "$PHOTO_PATH" ]]; then
  echo "Usage: moves_geotag.sh /Volumes/your_photos_disk/path/to/photos [/optional/path/to/downloaded/tracks]"
  exit
fi

# List dates for all photos in the directory
# FIXME: this might be done better without jq
DATES=$(exiftool -if 'not $GPSLatitude' -j -d '%Y-%m-%d' -CreateDate "$PHOTO_PATH" | jq '.[]|.CreateDate' | uniq)

if [[ -z "$DATES" ]]; then
  echo "No non-geotagged photos found in $PHOTO_PATH"
  exit
fi

# We can't just download the tracks with curl or something because they require authentication.
echo "Download these tracks into $DOWNLOADS_PATH:"
for DATE in $DATES; do
  TRACK_DATE=$(echo "$DATE" | sed 's/"//g;s/-//g')
  echo "http://www.moves-export.com/gpxactivity?type=storyline&startdate=$TRACK_DATE"
done

read -p "Hit ENTER to continue."

for DATE in $DATES; do
  FILENAME_DATE=$(echo "$DATE" | sed 's/"//g;s/-//g')
  # The non-uppercase $variables in this command are exiftool variables. Do not confuse with shell variables
  # Enumerate all files for this date, then geotag them using the track.
  # We can't do this for all photos in one command, because the Moves-Export tracks start not at midnight, but at the time of the first movement.
  # For example, if you left home at 8AM, the track will start at 8AM. Photos before 8AM will not have a geolocation using default exiftool settings.
  # But we know for sure the photos wre made at home.
  # Thus, we tell exiftool to track all photos before and after the track at the starting point. But then we have to
  # limit photos by date because otherwise the track will bleed out to other days (that have their own tracks).
  exiftool -d '%Y-%m-%d' -if "\$CreateDate eq $DATE and not \$GPSLatitude" -p '$Directory/$FileName' "$PHOTO_PATH" | \
    xargs exiftool -api GeoMaxIntSecs=86400 -api GeoMaxExtSecs=86400 -geotag="$DOWNLOADS_PATH/storyline_$FILENAME_DATE.gpx"
done
