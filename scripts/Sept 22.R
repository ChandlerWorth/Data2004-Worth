# pacakges
library(tidyverse)

# let's start with the same persons_core and crashes_core 
crashes <- read_csv("data/raw/crashes.csv")
persons <- read_csv("data/raw/person.csv")

crashes_core <- crashes |> 
  select(
    COLLISION_ID,
    `CRASH DATE`,
    BOROUGH,
    `NUMBER OF PERSONS INJURED`,
    `NUMBER OF PERSONS KILLED`
  )

persons_core <- persons |> 
  select(
    UNIQUE_ID,
    COLLISION_ID,
    PERSON_TYPE,
    PERSON_INJURY,
    PERSON_AGE,
    PERSON_SEX
  )

glimpse(crashes_core)
glimpse(persons_core)

# let's do a brief review of our mutating joins :) 

## what are the primary keys? what about the foreign key? 
### Primary Keys, Identify rows in a data set. Foreign Keys, link data sets together
### will be the primary key of greater than or equal to 1 other data set.
## what are our mutating joins? what's the difference? 
### left_join, keeps all rows in left data set, matches, matched keys, unmatched 
### will have NA for columns from right hand data frame.
### inner_join, keeps rows only where keys matching left and right data set
## let's check out the homework briefly. 

# Which crashes involved at least one bicyclist? I want one row per crash. 
# we'll start by making a table of just the bicyclist person records. how many are there?

bicyclist <- persons %>% 
  filter(PERSON_TYPE == "Bicyclist")

nrow(bicyclist)
n_distinct(bicyclist$COLLISION_ID)

crashes_bike <- crashes_core %>% 
  left_join(persons_core, join_by(COLLISION_ID))

crashes_bike <- crashes_bike %>% 
  filter(PERSON_TYPE == "Bicyclist")

glimpse(crashes_bike)

crashes_bike <- crashes_core %>% 
  left_join(bicyclist, join_by(COLLISION_ID))

glimpse(crashes_bike)


# does that number answer our question? why not? 

# if it doesn't, which join should we reach for?

# use nrow() on the join and n_distinct() on that join's collision ID. Why are they different? 

# we can answer this by thinking about the grain.
# we're joining persons to the crashes grain, so what does one row represent? 

# is it every crash involving a bicyclist? let's check out the first 10 rows.

crashes_bike %>% 
  slice_head(n=10)


# our mutating join adds columns so it has changed our grain, but we don't want it to right now. 

# so we'll need to use *filtering* joins
# we got exposed to one filtering join already: anti_join(). 
# which filtering join that will keep matches instead of non-matches?

bike_crashes <- crashes_core %>% 
  semi_join(bicyclist,join_by(COLLISION_ID))

nrow(bike_crashes)

n_distinct(bike_crashes$COLLISION_ID)

glimpse(bike_crashes)


# this doesn't add more columns, so we're not working with crash-bicyclists combination

# now do anti_join for crashes that do not involve a bicyclist. 

no_bike_crashes <- crashes_core %>% 
  anti_join(bicyclist, join_by(COLLISION_ID))

nrow(no_bike_crashes)


# what should the nrow() of each of your filtering joins dataframes be?

nrow(bike_crashes) + nrow(no_bike_crashes) == nrow(crashes_core)












# now it's y'all's turn: identify crashes that involve at least one pedestrian, 
# one row per crash. 

pedestrian <- persons %>% 
  filter(PERSON_TYPE == "Pedestrian")

crashes_pedestrian <- crashes_core %>% 
  semi_join(pedestrian, join_by(COLLISION_ID))

glimpse(crashes_pedestrian)


## after that, narrow it down. crashes where at least one pedestrian was recorded as female. 

females_pedestrian <- persons_core %>% 
  filter(PERSON_SEX == "F")
  
females_pedestrian <- persons_core %>% 
  filter(PERSON_SEX == "F") %>% 
  filter(PERSON_TYPE =="Pedestrian") %>% 
  semi_join(females_pedestrian, join_by(COLLISION_ID))


# back together
## where did you put the PERSON_SEX condition? why?
# I put it into the a filter for persons_core so that it would be in the data 
# because it wasn't in the pedestrians data we filtered earlier