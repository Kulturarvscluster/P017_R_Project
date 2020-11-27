## Funktion: Til stede uden replikker
#source(here("p017-functions.R"))

# This function calculates characters that are present, but silent, in 
# each scene in each act in a given play
present_without_speech <- function(play) {
  # Read plays
  convert_TEI_to_JSONL(here("test-data"))
  plays <- read_plays_jsonl(here("test-data"))
  # Find speakers
  plays %>%
    filter(title == play) %>%
    count(speaker) %>%
    mutate(speaker = str_to_lower(speaker)) %>%
    select(speaker) -> speakers_in_play
  # Find alle regi-bemærkninger. 
  plays %>%
      filter(title == play) %>% 
      unnest_tokens(word, stage) %>% #tokenize stage
      filter(!is.na(word)) %>%
      select(act, scene, index, word) -> stage_tokens_in_play
  
  plays %>%
      filter(title == play) %>% 
      unnest_tokens(word, speaker_stage) %>% #tokenize speaker stage
      filter(!is.na(word)) %>%
      select(act, scene, index, word) -> speaker_stage_tokens_in_play
  # Search for speakers in instructions
  stage_tokens_in_play %>%
      semi_join(speakers_in_play, by = c("word" = "speaker")) -> speakers_in_stage_play
  
  speaker_stage_tokens_in_play %>%
      semi_join(speakers_in_play, by = c("word" = "speaker")) -> speakers_in_speaker_stage_play
  
  speakers_in_stage_play %>%
      full_join(speakers_in_speaker_stage_play) -> all_speakers_in_stage_play
  # Remove the speakers, that are actually speaking?!
  ## Distinct speakers in each scene in each act   
  plays %>%
      filter(title == play) %>% 
      filter(!is.na(speaker)) %>%
      select(act, scene, speaker) %>%
      mutate(speaker = str_to_lower(speaker)) %>%
      group_by(act, scene)  %>%
      distinct() -> distinct_speakers_play
  
  ## Filter out speakers from words grouped by act and scene!
  all_speakers_in_stage_play %>%
    group_by(act, scene) %>%
    anti_join(distinct_speakers_play, by = c("word" = "speaker"))
}


