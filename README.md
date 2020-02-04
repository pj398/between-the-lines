# Between the Lines
## Pete Jones
### A repository for sharing data, tools and info related to my research on using character interaction networks to examine gendered character positions in popular film narratives.

For the last few years I've been manually collecting directed dialogue network data from popular films in order to explore what a network-based approach can add to our understanding of the narrative marginalisation of women in mainstream Hollywood cinema. 

To date, the only visible output of my research is [a paper I published in *Feminist Media Studies*](https://doi.org/10.1080/14680777.2018.1510846) analysing the distribution of dialogue in the film *Wonder Woman* (2017). That paper serves as a nice intro to my research, but didn't provide any data or reproducible code.

The goal of this repository then is to a) share the data I've collected, and b) provide code for reproducing my work.

This is a work-in-progress, but for now the following notebooks are available:

| Notebook  | HTML  |
| -----	| ----- |
| [01-FilmPipeline](01-FilmPipeline.Rmd) | [HTML](https://pj398.github.io/between-the-lines/notebooks/01-FilmPipeline.html) |
| [02-WonderWoman](02-WonderWoman.Rmd) | [HTML](https://pj398.github.io/between-the-lines/notebooks/02-WonderWoman.html) |
| 03-DynamicCentrality |  Coming soon |

`01-FilmPipeline` is an interactive notebook walking through the development of a simple pipeline for reading in the raw data, summarising and plotting the character interaction networks (all in R). It explains the purpose of the functions found in the `film-functions.R` script in this directory, which can be used to streamline the pipeline to a few lines of code which can then be used to read in, summarise and plot any new character interaction network data.

`02-WonderWoman` simply directs readers to the `wonder-woman` folder, which contains data and two more notebooks relevant to the *Wonder Woman* paper mentioned above. For more info, take a look at that folder's `README`.

Next steps:
- I will add a notebook containing the implementation of the dynamic narrative centrality measure I have presented at a number of recent conferences.
- I will add the remaining data I have collected throughout my thesis.
- I will improve the code and package-ify everything I've done to make it easier to use.

Stay tuned and let me know if I can be of any help.

## Contact

E-mail: pete.jones@manchester.ac.uk / petejones398@gmail.com  
Twitter: [@pj_mcr](https://twitter.com/pj_mcr)

## License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
