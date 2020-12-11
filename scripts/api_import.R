### step 1:
#spotifyR package
####

# install.packages('devtools')
# devtools::install_github('charlie86/spotifyr')
library(spotifyr)
library(tidyverse)

### step 2:
#api credentials
####
Sys.setenv(SPOTIFY_CLIENT_ID = '49946c3cdae2489481997f455f31f17b')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'ebffa4d17c06448ea2533bd75aa99d06')

access_token <- get_spotify_access_token()

### step 3:
# find popularity of tracks with get_track
####

library(spotifyr)
beatles <- get_artist_audio_features('the beatles')

track2 <- get_track('3WLuAuriiY82ESRvpmA8Ms')
track2[['popularity']]
track3 <- get_track('52vA3CYKZqZVdQnzRrdZt6')
track3[['popularity']]

beatles <- get_artist('3WrFJ7ztbogyGnTHbHJFl2')
test <- get_album_tracks('1WMVvswNzB9i2UMh9svso5')
