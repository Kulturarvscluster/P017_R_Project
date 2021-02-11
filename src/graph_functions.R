## Graf-funktioner
#source(here("graph_functions.R"))

# This function finds distinct speakers in each scene in each act grouped by act and scene
find_speakers <- function(play) {
  play %>%
    filter(!is.na(speaker)) %>%
    filter(!(speaker == "")) %>%
    select(speaker, act_number, scene_number) %>% 
    group_by(act_number, scene_number)  %>%
    distinct()
}

# This function joins speakers spelled differently in Mascarade
join_speakers_mascarade <- function(speakers) {
  speakers %>%
  # count all versions of Leander as one
  mutate(
    speaker = if_else(speaker %in% c("Leander", "Leander på Knæ"), "Leander", speaker)) %>%
    
    # count all versions of Barselskvinden as one
    mutate(
      speaker = if_else(speaker %in% c("Barselskonen", "Barselskvinden", "Barselsqvinde"), "Barselskvinden", speaker)) %>% 
    
    # Count all versions of kællingen as one
    mutate(
      speaker = if_else(speaker %in% c("Kælling", "Kællingen"), "Kællingen", speaker))
    
    
}

# This function turns distinct speakers into nodes with an id
speakers2nodes <- function(speakers) {
  speakers %>%
    ungroup() %>%
    select(speaker) %>%
    distinct() %>% 
    rowid_to_column("id")# add id column
}

# This function creates an edge for each pair of speakers in each scene in each act
# The input data must be grouped by act-number and scene-number
find_edges <- function(distinct_speakers) {
  #create column 'speaker2' and make it equal to 'speaker' (duplicate).
  distinct_speakers$speaker2 = distinct_speakers_$speaker 
  # All possible combinations (remember the data is still grouped by act-number and scene-number)
  distinct_speakers %>% 
      expand(speaker, speaker2) -> who_speaks_to_whom
  
  who_speaks_to_whom  %>%
      ungroup() %>%
      select(from = speaker, to = speaker2) %>%
      distinct() -> edges_Barselstuen
}