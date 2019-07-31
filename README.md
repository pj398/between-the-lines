# Between the Lines
## Pete Jones
### A repository for sharing data, tools and info related to my research on using character interaction networks to examine gendered character positions in popular film narratives.

For the last few years I've been manually collecting directed dialogue network data from popular films in order to explore what a network-based approach can add to our understanding of the narrative marginalisation of women in mainstream Hollywood cinema. To date, the only visible output of my research is [a paper I published in *Feminist Media Studies*](https://doi.org/10.1080/14680777.2018.1510846) analysing the distribution of dialogue in the film *Wonder Woman* (2017). That paper serves as a nice intro to my research, but doesn't provide any data or reproducible code.

I'm still getting set up here, so for now the only data you'll find here is the raw dialogue data for the movie *Frozen* as I wanted to at least get something ready to share  while I work on cleaning up the rest of what I have. 

An interactive notebook walking through the development of a simple pipeline for reading in the raw data, summarising and plotting the character networks (all in R) can be viewed in html (`01-FilmPipeline.nb.html`) or reproduced in RStudio (`01-FilmPipeline.Rmd`). As explained towards the end of the notebook, the `Film functions.R` script can be used to streamline the pipeline by simply sourcing in the functions and using them to read in, summarise and plot the dialogue network data.

Next steps:
- I will add the data and code for reproducing the analysis in the [*Wonder Woman* paper](https://doi.org/10.1080/14680777.2018.1510846) as soon as I find time.
- I will add a separate notebook containing the implementation of the dynamic narrative centrality measure I have presented at a number of recent conferences.
- I will add all other data I have collected throughout my thesis.
- Some exciting stuff bringing together everything here that I am keeping schtum about for now.

Stay tuned and let me know if I can be of any help.

## Contact

E-mail: petejones398@gmail.com  
Twitter: [@pj_mcr](https://twitter.com/pj_mcr)

## License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
