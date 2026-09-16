library(tidyverse)

library(readxl)

fishing <- read_excel("data/raw/commercial.xlsx", sheet = "Erie")

glimpse(fishing)

# What does one row represnt?
## One row represents region weight of fish caught, rounded pounds.
# How would we look at our grain over time by region?
## 
fishing %>% 
  ggplot(aes(x = Year, y = `Grand Total`)) +
  geom_line()

# What does on the y axis?

# What goes on the x axis?

# Lets predict something
nrow(fishing)

# We're about to move 7 columns into one. How many rows shoudl we have?

#Pivot

fishing_longer <- fishing %>%
  pivot_longer(
    names_to = "region",
    values_to = "values",
    cols = !c(Year, Lake, Species, Comments))

nrow(fishing_longer)

fishing_longer %>%
  distinct(region)

fishing_longer %>%
  filter(Year == 1885, Species == "Lake Whitefish") %>%
  select(region, values)

fishing_longer %>% 
  filter(!region %in% c("U.S. Total", "Grand Total")) %>% 
  summarise(total = sum(values, na.rm = TRUE)
  ) %>% 
  mutate(Species = fct_lump_n(Species, 6))
fishing_longer %>%
  filter(!region %in% c("U.S. Total", "Grand Total")) %>%
  ggplot(aes(x = Year, y = values, color = Species)) +
  geom_line()


fishing_longer %>%
  select(Year, Species, region, values) %>% 
  pivot_wider(names_from = region, values_from = values) %>%
  print(width = Inf)

# Now let's break. Choose a differnt sheet in spreadsheet.
# What is the grain?
## Same as above, one row represents region weight of fish caught, rounded pounds.
# What is the total catch for that lake?
## 1783703
# What distinct regions are you left with?
## 
# How many rows did you start with? How many did your pivot have?
## I started with 1673 rows and now have 10038

fishing_two <- read_excel("data/raw/commercial.xlsx", sheet = "Superior")

glimpse(fishing_two)

sum_grand_total <- sum(fishing_two$"Grand Total", na.rm = TRUE)

fishing_two_longer<- fishing_two %>%
  pivot_longer(
    names_to = "region",
    values_to = "values",
    cols = !c(Year, Lake, Species, Comments))

nrow(fishing_two_longer)

