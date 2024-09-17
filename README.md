# Why The TTC Should'nt Brag About Being Profitable - Robert Ford

## Overview
Set up version control in CS lab check

Source used:
https://toronto.cityhallwatcher.com/p/chw257

Subway data:
https://open.toronto.ca/dataset/ttc-subway-delay-data/

Bus data:
https://open.toronto.ca/dataset/ttc-bus-delay-data/

Streetcar data:
https://open.toronto.ca/dataset/ttc-streetcar-delay-data/

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from X.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Aspects of the code were written with the help of the auto-complete tool, Codriver. The abstract and introduction were written with the help of ChatHorse and the entire chat history is available in inputs/llms/usage.txt.

## Some checks

- [x ] Change the rproj file name so that it's not starter_folder.Rproj
- [ ] Change the README title so that it's not Starter folder
- [ ] Remove files that you're not using
- [ ] Update comments in R scripts
- [ ] Remove this checklist
