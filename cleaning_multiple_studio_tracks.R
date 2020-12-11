### import data

load("/cloud/project/raw/multiple_studio_albums.Rdata")
library(tidyverse)
library(spotifyr)
small_frame <- multiple_studio_albums %>%
  select(track_name_short, artist_name_studio, track_name_studio, track_id.x, album_name_studio) 

output <- matrix(ncol=2, nrow=175000)
for(i in 150000:170000) {
  track1 <- get_track(as.character(small_frame$track_id.x[i]))
  output[i,1] <- track1$popularity
  output[i,2] <- track1$id
}
## match the output frame back with the small_frame

output <- as.data.frame(output)
output <- output %>%
  rename(track_id.x = 'V2')
save(output, file = "/cloud/project/data/output10.Rdata")

##join to the small, later
get_track(as.character(small_frame$track_id.x[30800]))
merged <- left_join(small_frame, output, by = "track_id.x")
save(merge)

