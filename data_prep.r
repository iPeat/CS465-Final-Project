setwd("/Users/Joy/Downloads")
library(dplyr)
primaries <- read.csv("primary_results.csv")
state_names <-read.csv("state_names.csv")

state_names<- state_names %>% 
  select(name, abbreviation) %>% 
  rename(state = name)
state_names

by_candidate_and_state <- primaries %>% 
  group_by(candidate, state) %>% 
  summarize(sum(votes)) %>% 
  rename(votes_candidate = `sum(votes)`)

by_candidate_and_state

total_votes_state <- primaries %>% 
  group_by(state) %>% 
  summarise(sum(votes)) %>% 
  rename(votes_state = `sum(votes)`)

total_votes_state

merged_data <- inner_join(by_candidate_and_state, total_votes_state, by = "state" ) 

merged_data <- merged_data %>% 
  mutate(prop = votes_candidate/votes_state)
merged_data <- merged_data %>% 
  filter(candidate!= " No Preference" & candidate!= " Uncommitted" )
merged_data <- left_join(merged_data, state_names)
write.csv(merged_data, file = "final_primary_data.csv")


  