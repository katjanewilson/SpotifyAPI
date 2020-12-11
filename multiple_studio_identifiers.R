#### pulling together data frame of unique identifiers
library(tidyverse)
load("/cloud/project/data/output1.Rdata")
output1<- output
load("/cloud/project/data/output2.Rdata")
output2<- output
load("/cloud/project/data/output3.Rdata")
output3<- output
load("/cloud/project/data/output4.Rdata")
output4<- output
load("/cloud/project/data/output5.Rdata")
output5<- output
load("/cloud/project/data/output6.Rdata")
output6<- output
load("/cloud/project/data/output7.Rdata")
output7<- output
load("/cloud/project/data/output8.Rdata")
output8<- output
load("/cloud/project/data/output9.Rdata")
output9<- output


output1<- output1[complete.cases(output1), ]
output2<- output2[complete.cases(output2), ]
output3<- output3[complete.cases(output3), ]
output4<- output4[complete.cases(output4), ]
output5<- output5[complete.cases(output5), ]
output6<- output6[complete.cases(output6), ]
output7<- output7[complete.cases(output7), ]
output8 <- as.data.frame(output8)
output8 <- output8 %>%
  rename(track_id.x = 'V2')
output8<- output8[complete.cases(output8), ]
output9<- output9[complete.cases(output9), ]


##bind them

total_output<- rbind(output1, output2)
total_output<- rbind(total_output, output3)
total_output<- rbind(total_output, output4)
total_output<- rbind(total_output, output5)
total_output<- rbind(total_output, output6)
total_output<- rbind(total_output, output7)
total_output<- rbind(total_output, output8)
total_output<- rbind(total_output, output9)

write.csv(total_output, file = "data/total_output.csv")
total_output <- total_output %>%
  distinct()
names_multiple <- multiple_studio_albums %>%
  select(track_id.x) %>%
  distinct()
## we need 80,0000 track ids
## we have 34,000
small_frame <- multiple_studio_albums %>%
  select(track_name_short, artist_name_studio, track_name_studio, track_id.x, album_name_studio) 
total_output <- read_csv("data/total_output.csv")
merged <- left_join(small_frame, total_output, by = "track_id.x")
merged <- merged %>%
  rename(popularity_index = 'V1') %>%
  select(popularity_index, artist_name_studio, track_name_studio, track_id.x, album_name_studio)
write.csv(merged, file = "data/merged_popularity.csv")
