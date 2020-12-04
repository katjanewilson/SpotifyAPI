# getwd()
# setwd("/Users/katwilson/Pudding_Final")
# save(total_bind, file = "/Users/katwilson/Pudding_Final/pudding_final_data/raw.Rdata")
# 


## use the total_bind
library(tidyverse)


working_data <- na.omit(total_bind)
working_data <- distinct(working_data)
save(working_data, file = "/Users/katwilson/Pudding_Final/pudding_final_data/raw_distinct.Rdata")
#change variables
working_data$energy <- as.numeric(working_data$energy)
working_data$danceability <- as.numeric(working_data$danceability)
working_data$acousticness <- as.numeric(working_data$acousticness)
working_data$valence <- as.numeric(working_data$valence)
working_data$tempo <- as.numeric(working_data$tempo)
working_data$instrumentalness <- as.numeric(working_data$instrumentalness)
working_data$speechiness <- as.numeric(working_data$speechiness)
working_data$duration <- as.numeric(working_data$duration_ms)
working_data$liveness <- as.numeric(working_data$liveness)
working_data$loudness<- as.numeric(working_data$loudness)
working_data <- working_data %>%
  mutate(livemarker = case_when(
    str_detect(track_name, "- Live") |
      str_detect(track_name, "(Live)") |
      str_detect(track_name, "(live)") |
      str_detect(track_name, "(LIVE)") |
      str_detect(album_name, "(LIVE)") |
      str_detect(track_name, "- live") |
      str_detect(album_name, "Live") |
      str_detect(album_name, "Sessions") |
      str_detect(album_name, "Sessions") |
      str_detect(album_name, "MTV Unplugged") ~ "live"))

working_data$livemarker[is.na(working_data$livemarker)] <- "studio"
table(working_data$livemarker)


working_data <- working_data %>%
  select(artist_name, album_name, track_name, valence,
         energy, instrumentalness, duration, liveness, 
         danceability, loudness, speechiness, acousticness,
         tempo, track_preview_url, album_images, livemarker)
working_data <- working_data %>%
  filter(!str_detect(track_name, 'Acoustic'),
         !str_detect(album_name, 'Box Set'),
         !str_detect(album_name, 'Collection'),
         !str_detect(track_name, 'Rehearsals'),
         !str_detect(album_name, 'Rehearsals'),
         !str_detect(track_name, 'Intro'),
         !str_detect(track_name, 'Introduction'),
         !str_detect(album_name, 'Track By Track'),
         !str_detect(track_name, 'Commentary'),
         !str_detect(album_name, 'Movie Soundtrack'))
### matching
working_data <- working_data %>%
  mutate(track_name_short = gsub("\\-.*","", track_name))
working_data <- working_data %>%
  mutate(track_name_short = gsub("\\s*\\([^\\)]+\\)","",as.character(track_name_short)))
working_data <- working_data %>%
  distinct()
working_data <- working_data %>%
  mutate(track_name_short = gsub(" ", "", track_name_short, fixed = TRUE))
working_data$track_name_short <- as.factor(working_data$track_name_short)
test<- working_data%>%
  filter(track_name_short == "LikeaRollingStone")

# livesongs <- working_data %>%
#   filter(livemarker == 'live') %>%
#   select(livemarker, track_name_short)
# joined <- left_join(working_data, livesongs, by = 'track_name_short') %>%
#   distinct() %>%
#   select(!livemarker.y)
# joined$track_name <- trimws(joined$track_name)

joined_s <- working_data %>%
  filter(livemarker == 'studio') %>%
  group_by(artist_name, album_name, track_name_short, track_preview_url, track_name, livemarker, album_images) %>%
  summarise(energy_studio = energy,
            dance_studio = danceability,
            acousticness_studio = acousticness,
            valence_studio = valence,
            instrumentalness_studio = instrumentalness,
            speechiness_studio = speechiness,
            tempo_studio = tempo,
            duration_studio = duration,
            liveness_studio = liveness)


joined_l <- working_data %>%
  filter(livemarker == 'live') %>%
  group_by(artist_name, album_name, track_name_short, track_preview_url, track_name, livemarker, album_images) %>%
  summarise(energy_live = energy,
            dance_live = danceability,
            acousticness_live = acousticness,
            valence_live = valence,
            instrumentalness_live = instrumentalness,
            speechiness_live = speechiness,
            tempo_live = tempo,
            duration_live = duration,
            liveness_live = liveness) %>%
  ungroup()


joined2 <- merge(joined_s , joined_l, by = c('track_name_short'))


joined2 <- joined2 %>%
  rename('artist_name_studio' = 'artist_name.x',
         'artist_name_live' = 'artist_name.y',
         'album_name_studio' = 'album_name.x',
         'album_name_live' = 'album_name.y',
         'track_preview_url_studio' = 'track_preview_url.x',
         'track_preview_url_live' = 'track_preview_url.y',
         'track_name_studio' = 'track_name.x',
         'track_name_live' = 'track_name.y',
         'album_images_studio' = 'album_images.x',
         'album_images_live' = 'album_images.y')
joined2 <- joined2 %>%
  mutate(difference_energy = energy_live - energy_studio,
         difference_dance= dance_live - dance_studio,
         difference_acousticness = acousticness_live - acousticness_studio,
         difference_valence = valence_live - valence_studio,
         difference_instrumentalness = instrumentalness_live - instrumentalness_studio,
         difference_speechiness = speechiness_live - speechiness_studio,
         difference_tempo = tempo_live - tempo_studio,
         difference_duration = duration_live - duration_studio,
         difference_liveness = liveness_live - liveness_studio
  )



save(joined2, file = "/Users/katwilson/Pudding_Final/pudding_final_data/joined2.Rdata")


### then edit it one more time to exclude false matches

final_data <- joined2 %>%
  mutate(match = ifelse(artist_name_live == artist_name_studio, 1,0))
final_data <- final_data %>%
  filter(match == 1)
save(final_data, file = "/Users/katwilson/Pudding_Final/pudding_final_data/final_data.Rdata")
