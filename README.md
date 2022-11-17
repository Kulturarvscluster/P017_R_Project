# P017 R project
This R project is part of the P017 DEICproject LUDVIG.

The project answers questions formulated in this document:
https://docs.google.com/document/d/1YeikoaHe36B4ajvxBHqMdovM7XVoSFLXBb1biJjotLs/edit?usp=sharing

In the `deliverables` folder you will find notebooks ready for usage.

In the `notebooks` folder you will find experimental things.

In the `src` folder you will find source code for more low level things.


## Read a Play
The `deliverables/read_plays.rmd` notebook explains how to transform a play from TEI to JSONL and how to read it into R.

## Visualizing who says how much in each scene

The `deliverables/visualisering-ord-sagt.Rmd` notebook shows how to extract information on how much is said by the different speakers, how to count different spellings of a speaker as one, and how to visualize such information.

## Find Characters
The "find_speakers.rmd" notebook finds characters; both speakers and characters in <stage> tags and in speach. 
**_Work in progress._**

The notebook writes a number of output files. For each play, these files will be produced:
* play_all_speakers.csv: navne på alle karakterer med replikker.
* play_speakers_by_scene.csv: alle karakterer med replikker opdelt på akt og scene.
* play_stage_instructions_by_scene.csv: regibemærkninger <stage> opdelt på akt og scene.
* play_combined_stage_instructions.csv: alle regibemærkninger.
* play_speaker_stage_instructions_by_scene.csv: regibemærkninger <speaker-stage> opdelt på akt og scene.

## Dramatiske Overgange
The "dramatiske_overgange.rmd" notebook finds the first and last spoken words in each scene. The output is written to:
* play_first_sentence.csv: første sætning i hver scene.
* play_last_sentence.csv: sidste sætning i hver scene.

## Required R packages

The following R package are assumed as being installed in most of the scripts and notebooks

 * tidyverse
 * ndjson
 * fs
 * xslt
 
They can all be installed with `install.packages("<package name>").
