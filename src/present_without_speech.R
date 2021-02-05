## Funktion: Til stede uden replikker
#source(here("p017-functions.R"))

# This function calculates characters that are present, but silent, in 
# each scene in each act in a given play
present_without_speech <- function(play) {
  # Find speakers
  play %>%
    filter(!is.na(speaker)) %>% 
    count(speaker) %>%
    mutate(speaker = str_to_lower(speaker)) %>%
    select(speaker) -> speakers_in_play
  # Find alle regi-bemærkninger. 
  # These are the people who are directly mentioned in the stage tokens
  play %>%
    filter(!is.na(stage)) %>%
    filter(!startsWith(stage, "("))  %>% 
    unnest_tokens(word, stage, drop=FALSE, token="regex", pattern = ", *") %>% #tokenize stage
    select(act, scene, index, word) %>% 
    distinct() -> stage_tokens_in_play
  
  # These are the the actors who are implicitly mentioned in stage tokens
  # Where is this used and how?
  (play %>% 
      filter(!is.na(stage)) %>%
      filter(startsWith(stage, "("))  %>% 
      unnest_tokens(word, stage) %>% #tokenize stage
      select(act, scene, index, word) %>% 
      distinct() -> implicit_stage_tokens)
  
  # These are the the actors who are implicitly mentioned in speaker stage tokens
  play %>%
      unnest_tokens(word, speaker_stage) %>% #tokenize speaker stage
      filter(!is.na(word)) %>%
      select(act, scene, index, word) -> speaker_stage_tokens_in_play
  
  # Search for speakers in instructions
  stage_tokens_in_play %>%
      semi_join(speakers_in_play, by = c("word" = "speaker")) -> speakers_in_stage_play
  
  speaker_stage_tokens_in_play %>%
      semi_join(speakers_in_play, by = c("word" = "speaker")) -> speakers_in_speaker_stage_play
  
  (implicit_stage_tokens %>%
      semi_join(speakers, by = c("word" = "speaker")) -> implicit_speakers_in_stage)
  
  speakers_in_stage_play %>%
      full_join(implicit_speakers_in_stage) %>% 
      full_join(speakers_in_speaker_stage_play) -> all_speakers_in_stage_play
  
  # Remove the speakers, that are actually speaking?!
  ## Distinct speakers in each scene in each act   
  play %>%
      filter(!is.na(speaker)) %>%
      select(act, scene, speaker) %>%
      mutate(speaker = str_to_lower(speaker)) %>%
      distinct() -> distinct_speakers_play
  
  ## Filter out speakers from words grouped by act and scene!
  all_speakers_in_stage_play %>%
    anti_join(distinct_speakers, by=c("act"="act", "scene"="scene", "word"="speaker")) %>% 
    distinct()
}


