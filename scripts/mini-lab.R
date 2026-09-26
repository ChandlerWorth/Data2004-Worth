# Lab 2

# We'll start by working with the actual crashes and persons fully 
library(tidyverse)

crashes <- read_csv("data/raw/crashes.csv")
persons <- read_csv("data/raw/person.csv")

# 1: Make a table of person records for female pedestrians 

pedestrian <- persons %>% 
  filter(PERSON_TYPE == "Pedestrian")

crashes_pedestrian <- crashes %>% 
  semi_join(pedestrian, join_by(COLLISION_ID))

glimpse(crashes_pedestrian)

females_pedestrian <- persons %>% 
  filter(PERSON_SEX == "F")

females_pedestrian <- persons %>% 
  filter(PERSON_SEX == "F") %>% 
  filter(PERSON_TYPE =="Pedestrian") %>% 
  semi_join(females_pedestrian, join_by(COLLISION_ID))

## what does one row represent? 
### One row represents one female pedestrin who was invloved in a crash. 

# 2: Keep only the crashes that involved at least one female pedestrian. 
# Keep COLLISION_ID, BOROUGH, and the five vehicle type columns. 
# how can we select every variable that starts with "VEHICLE TYPE CODE"?

female_crashes_pedestrian <- crashes |> 
  select(
    COLLISION_ID, BOROUGH, `VEHICLE TYPE CODE 1`, `VEHICLE TYPE CODE 2`, `VEHICLE TYPE CODE 3`,
    `VEHICLE TYPE CODE 4`,`VEHICLE TYPE CODE 5`)

female_crashes_pedestrian_new <- female_crashes_pedestrian %>% 
  semi_join(females_pedestrian, join_by(COLLISION_ID))

# does one row still represent one crash? check it. 

# why a filtering join instead of a mutating join? 

# 3: Right now the vehicle types are columns. We want one row per vehicle. 
# before writing your code, how many rows should we have? 
# 5119


# how many missing values are in the new dataframe? 

female_crashes_pedestrian_new %>% 
  count("NA")
# 4940
# why do we think that slots 3, 4, and 5 have so many more missing values? 
# whoever took record of the crashes may have just not gone into too much detail about the crash and car type.

# does every crash have a first vehicle recorded? 
# No, most do but not everyone

# are we safe to drop missing values?
# No because then we would lose some of the crashes. 
# 5: what kinds of vehicles are involved in crashes with a female pedestrian? 

vehicle_reports <- female_crashes_pedestrian_new |> 
  count(`VEHICLE TYPE CODE 1`, sort = TRUE) |> 
  print(n = 40)

