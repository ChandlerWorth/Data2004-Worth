# Lab 2: is this file ready to analyze?

library(tidyverse)


# you're a junior analyst at a state library association. a colleague
# downloaded the 2024 Public Libraries Survey and wants to compare
# library systems on visits, circulation, and programs.

# your supervisor wants an audit before anyone analyzes anything.

# nothing today is new. you've done every piece of this already.


# grain and key

libraries <- read_csv(
  "PLS_FY24_AE_pud24i.csv",
  locale = locale(encoding = "latin1"),
  show_col_types = FALSE
)

glimpse(libraries)

# one row is one administrative entity, or library system.

# the download also has an "outlet" file. it has more rows.
# why would it? (the user's guide will tell you.) There is more info about 
# each library in the outlest file the other one is just an administrative key. 

# which column should identify a row? The FSCSKEY

libraries |> 
  count(FSCSKEY) |> 
  filter(n>1)

# what did those tell you? 
# It told us that is was unique to each row
# what would it have meant if the count() came back with rows?
# it would mean that there are dupplicates in the data set of the FSCSKEY


# let's focus on VISITS for now. what does this column mean?
# it is the total annual library visits. 

# VISITS counts visits to the library in a year.
# before you run anything: what values would be impossible?
# negative values would be impossible. 

libraries |>
  summarise(
    min_visits = min(VISITS, na.rm = TRUE),
    max_visits = max(VISITS, na.rm = TRUE)
  )

libraries |>
  filter(VISITS < 0) |>
  count(VISITS)

# how many different negative values? how many rows of each?
# there are two different negative values

# is a negative number here bad data, missing data, or a code?
# can you tell from the data alone?
# I think its a code, you can't tell from the data alone you must look 
# at the documentation to find this out. 

# does R think any of these are missing?
# No it doesn't think any are missing.

is.na(libraries$VISITS) |>
  table()

# on tuesday, NA told us THAT something was missing but not WHY.
# what's different here?
# What is different it because it is now apart of the code, it is not a missing 
# value it is a value that determines what is going on in the data. 


# go to the user's guide. for each negative value:
# what does it mean, in the guide's words? where did you find it?
# I found it in the text file under the Recoding Negative Values to Missing in SAS section
# if num = -1 then num = .M; /*recode missing value into .M*/
# if num = -3 and STATSTRU ='23' then num = .C; /*recode Temporary Closed

# do the two codes mean the same thing?
# No they do not mean the same thing, one is missing values, and one is 
# temporaryily closed libraries. 

# every numeric column has a flag column. find the one for VISITS.
# F_Visits

# what does the flag tell you? does it tell the two codes apart?
# It tells us a different flag code that can be discerned by the Flag appendix. 

# make a clean version. VISITS stays exactly as it is.

libraries <- libraries |>
  mutate(visits_clean = if_else(VISITS %in% c(-1, -3), NA_real_, VISITS))

# why list the codes instead of writing VISITS < 0?
# Because those two codes have been listed in the documentation to mean 
# specific things, if there is another negative I would assume it is an error. 

# both codes just turned into NA. what did we lose?
# where can we still find it?
# We lose the reasons about why it is missing. 
# You can still find it in the flags column. 

# did it do what we meant? three questions:
# same number of library systems?
# did every code become NA?
# did anything else become NA?

# Yes the same number of library systems use the same codes. Nothing else became 
# NA besides those -1 and -3's

# does any of this matter?
# Yes, we know what the code book looks like and also the codes they are using. 

# why is the raw mean lower? what's in each denominator?
# it is lower because the negatives are dragging it down

# your turn :)
# get in your group project groups

# do that process for each of the following:
# TOTATTEN - program attendance
# TOTPRO - number of programs
# TOTCIR - total circulation

libraries |>
  summarise(
    min_totatten = min(TOTATTEN, na.rm = TRUE),
    max_totatten = max(TOTATTEN, na.rm = TRUE)
  )

libraries |>
  filter(VISITS < 0) |>
  count(VISITS)

is.na(libraries$TOTATTEN) |>
  table()

libraries <- libraries |>
  mutate(totatten_clean = if_else(TOTATTEN %in% c(-1, -3), NA_real_, TOTATTEN))

libraries |>
  summarise(
    min_totpro = min(TOTPRO, na.rm = TRUE),
    max_totpro = max(TOTPRO, na.rm = TRUE)
  )

libraries |>
  filter(TOTPRO < 0) |>
  count(TOTPRO)

is.na(libraries$TOTPRO) |>
  table()

libraries <- libraries |>
  mutate(totpro_clean = if_else(TOTPRO %in% c(-1, -3), NA_real_, TOTPRO))


libraries |>
  summarise(
    min_totcir = min(TOTCIR, na.rm = TRUE),
    max_totcir = max(TOTCIR, na.rm = TRUE)
  )

libraries |>
  filter(TOTCIR < 0) |>
  count(TOTCIR)

is.na(libraries$TOTCIR) |>
  table()

libraries <- libraries |>
  mutate(totcir_clean = if_else(TOTCIR %in% c(-1, -3), NA_real_, TOTCIR))

# you're not solving a new problem. same steps, different variable.
# everything you need is in the VISITS section.

# what should it measure? what would be impossible?
# It should measure total attendance, programs, and circulation. It should 
# be impossible to have a negative value. 


# range. any odd values? how many of each?
# yes there are odd values, there are two negative values, -1 and -3. 

# what does the user's guide say they mean?
# ("we couldn't find it" is an answer. "we assumed" isn't.)
# if num = -1 then num = .M; /*recode missing value into .M*/
# if num = -3 and STATSTRU ='23' then num = .C; /*recode Temporary Closed

# what's the flag column? (the names get shortened. look for it.)
# It tells us a different flag code that can be discerned by the Flag appendix.

# clean version. keep the raw column.

# check it: same rows? every code became NA? nothing else did?
# yes, every row that had a -1 or -3 became an NA. Nothing else did with that. 

# mean before and after. big change or small?
libraries |>
  summarise(
    mean_totatten = mean(TOTATTEN, na.rm = TRUE),
    mean_after_totatten = mean(totatten_clean, na.rm = TRUE)
  )

# where are they? 
# the N/A were dropped

# recoding to NA fixes the number. does it finish the job?

# are the coded rows spread out, or do they bunch up?

# if someone compares circulation across states, what goes wrong?


# this is for you to answer
# is this file ready to analyze as is? 3-4 sentences.
# I think it is dependent on what you are trying to do with it or what you want to figure out. 
# You could do more cleaning to make it easier to read but also the code does 
# not take care of every column. We have cleaned it for only a few of the columns. 

