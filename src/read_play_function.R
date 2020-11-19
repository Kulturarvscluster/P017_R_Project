# Read Play Function

library(xml2)
library(tidyverse)
library(ndjson)
library(here)

read_play <- function(page_file, jsonl_file) {
  # read the TEI file to find title and year
  xml_doc <- read_xml(here(page_file))
  
  # <titlePart type="main">
  title <- xml_find_all(
    xml_doc, xpath = "//tei:titlePart[@type='main']",
    ns = c(tei = "http://www.tei-c.org/ns/1.0")
  )
  
  # <titlePart type="sub"> Skal den med?
  
  # <byline rend="center">
  year <- xml_find_all(
    xml_doc, xpath = "//tei:byline[@rend='center']",
    ns = c(tei = "http://www.tei-c.org/ns/1.0")
  )
  
  # read the JSONL file and add title and year as columns
  play <- ndjson::stream_in(here(jsonl_file)) %>% tibble() %>%
    add_column(title = str_squish(xml_text(title)), year = str_squish(xml_text(year)), .before = 0)
  return(play)
}
