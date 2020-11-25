# This function takes on argument:
#   folder: the path to a folder containing one or more
#           TEI files with the .page extension
#
# The function creates JSONL versions of these files, and
# stores them in the same folder
# The function assumes the existence of two XSLT scripts present
# in the src folder of the project.
convert_TEI_to_JSONL <- function(folder) {
  # Load the XSL tranformations
  stripSeqXSL <- read_xml(here("src","stripSeq.xslt"))
  # TODO: add a column with all the titles
  tei2jsonlXSL <- read_xml(here("src","tei2jsonl.xslt"))
  
  # convert all .page files in the "test-data/tei" directory to JSONL files
  dir_walk(
    folder,
    function(filename) if (str_ends(filename,".page")) filename %>%
      read_xml() %>%
      xml_xslt(stripSeqXSL) %>%
      xml_xslt(tei2jsonlXSL) %>%
      write_file(path(path_ext_remove(filename), ext="jsonl")))
}



# This function read all JSONL files in a folder into
# a tibble, adding a index numbering each scene within each play
read_plays_jsonl <- function(folder) {
  dir_ls(folder, glob = "*.jsonl") %>% 
    map_dfr(
      ~ndjson::stream_in(.) %>%
        tibble()
    )
}