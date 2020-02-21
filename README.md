
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Between the Lines

<!-- badges: start -->

<!-- badges: end -->

## Pete Jones

### A repository for sharing data, tools and info related to my research on using character interaction networks to examine gendered character positions in popular film narratives.

For the last few years I’ve been manually collecting directed dialogue
network data from popular films in order to explore what a network-based
approach can add to our understanding of the narrative marginalisation
of women in mainstream Hollywood cinema.

To date, the only visible output of my research is [a paper I published
in *Feminist Media
Studies*](https://doi.org/10.1080/14680777.2018.1510846) analysing the
distribution of dialogue in the film *Wonder Woman* (2017). That paper
serves as a nice intro to my research, but didn’t provide any data or
reproducible code.

The goal of this repository then is to a) share some of the data I’ve
collected\[1\], and b) provide code for reproducing my work.

This is a work-in-progress, but for now the following notebooks are
available:

| Notebook                                         | HTML                                                                                  | Notes                                                                                                                                                                             |
| ------------------------------------------------ | ------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [01-FilmPipeline](01-FilmPipeline.Rmd)           | [HTML](https://pj398.github.io/between-the-lines/notebooks/01-FilmPipeline.html)      | An interactive notebook walking through the development of a simple pipeline for reading in the raw data, summarising and plotting the character interaction networks (all in R). |
| [02-WonderWoman-paper](02-WonderWoman-paper.Rmd) | [HTML](https://pj398.github.io/between-the-lines/notebooks/02-WonderWoman-paper.html) | An interactive notebook walking through and reproducing the analysis from the 2018 *Wonder Woman* paper.                                                                          |
| [03-WonderWoman-text](03-WonderWoman-text.Rmd)   | [HTML](https://pj398.github.io/between-the-lines/notebooks/03-WonderWoman-text.html)  | An interactive notebook walking through some additional text analysis which isn’t in the 2018 paper but adds some additional analysis to the discussion.                          |
| 04-DynamicCentrality                             | Coming soon                                                                           | Coming soon                                                                                                                                                                       |

Next steps:

  - I will add a notebook containing the implementation of the dynamic
    narrative centrality measure I have presented at a number of recent
    conferences.
  - ~~I will add the remaining data I have collected throughout my
    thesis.~~ See [movienetData](https://github.com/pj398/movienetData).
  - I will improve the code and package-ify everything I’ve done to make
    it easier to use.

Stay tuned and let me know if I can be of any help.

## Contact

E-mail: <pete.jones@manchester.ac.uk> / <petejones398@gmail.com>  
Twitter: <a href="https://twitter.com/pj_mcr">@pj\_mcr</a>

## License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This
work is licensed under a
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative
Commons Attribution-NonCommercial-ShareAlike 4.0 International
License</a>.

1.  I have since created a data package called
    [movienetData](https://github.com/pj398/movienetData) which is a
    more effective way for you to access the data, especially if you are
    an *R* user.
