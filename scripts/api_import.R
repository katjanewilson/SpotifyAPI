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
Sys.setenv(SPOTIFY_CLIENT_ID = 'XXX')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'XXx')

access_token <- get_spotify_access_token()

### step 3:
# find popularity of tracks with get_track
####

library(spotifyr)
beatles <- get_artist_audio_features('the beatles')

track <- get_track('183Klch3PBWLz2S6zNUVxR')
track2 <- get_track('42ZKztg2UwEBRP5TvQUdOu')
track2[['popularity']]

beatles <- get_artist('3WrFJ7ztbogyGnTHbHJFl2')
test <- get_album_tracks('1WMVvswNzB9i2UMh9svso5')
