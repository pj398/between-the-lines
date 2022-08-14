
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Between the Lines

<!-- badges: start -->
<!-- badges: end -->

## Pete Jones

### NOTE: The material in this repo has been completely superceded by other work. I will leave this repo up because my thesis directs readers to it, but for those interested in the code, an improved and cleaner version is implemented in the [charinet](https://github.com/pj398/charinet) package; while for those interested in the data, this has been implemented for some time in the [movienetdata](https://github.com/pj398/movienetdata) package. The only thing contained here which is not better represented elsewhere is the notebook reproducing the analysis in the *Wonder Woman* paper.

------------------------------------------------------------------------

#### A repository for sharing data, tools and info related to my research on using character interaction networks to examine gendered character positions in popular film narratives.

As I prepared my [doctoral
thesis](https://www.research.manchester.ac.uk/portal/en/theses/a-social-network-analysis-approach-to-examining-gendered-character-positions-in-popular-film-narratives(76aa86f6-1c00-4d01-830f-1e6dafe4d798).html)
on what a network-based approach can add to our understanding of the
narrative marginalisation of women in mainstream Hollywood cinema, I
developed this repo as a set of supplementary materials that I could
refer to in the thesis for the code and data.

I prepared the materials in the form of R notebooks, which R users can
run themselves, and HTML versions of those notebooks. I focused on
recreating the kind of pipeline that I used after collecting character
interaction data to read those data into R and summarise and visualise
them. I also reproduced the analysis in [a paper I published in
*Feminist Media Studies*](https://doi.org/10.1080/14680777.2018.1510846)
analysing the distribution of dialogue in the film *Wonder Woman*
(2017). That paper serves as a nice intro to my research, but didn’t
provide any data or reproducible code.

Here are the notebooks I created:

| Notebook                                         | HTML                                                                                  | Notes                                                                                                                                                                             |
|--------------------------------------------------|---------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [01-FilmPipeline](01-FilmPipeline.Rmd)           | [HTML](https://pj398.github.io/between-the-lines/notebooks/01-FilmPipeline.html)      | An interactive notebook walking through the development of a simple pipeline for reading in the raw data, summarising and plotting the character interaction networks (all in R). |
| [02-WonderWoman-paper](02-WonderWoman-paper.Rmd) | [HTML](https://pj398.github.io/between-the-lines/notebooks/02-WonderWoman-paper.html) | An interactive notebook walking through and reproducing the analysis from the 2018 *Wonder Woman* paper.                                                                          |
| [03-WonderWoman-text](03-WonderWoman-text.Rmd)   | [HTML](https://pj398.github.io/between-the-lines/notebooks/03-WonderWoman-text.html)  | An interactive notebook walking through some additional text analysis which isn’t in the 2018 paper but adds some additional analysis to the discussion.                          |
| 04-DynamicCentrality                             | ~~Coming soon~~                                                                       | ~~Coming soon~~ See below.                                                                                                                                                        |

Next steps:

-   ~~I will add a notebook containing the implementation of the dynamic
    narrative centrality measure I have presented at a number of recent
    conferences.~~ See [this blog
    post](https://www.petejon.es/posts/2020-04-30-narrative-centrality/).
-   ~~I will add the remaining data I have collected throughout my
    thesis.~~ See [movienetdata](https://github.com/pj398/movienetdata).
-   ~~I will improve the code and package-ify everything I’ve done to
    make it easier to use.~~ See
    [charinet](https://github.com/pj398/charinet).

Let me know if I can be of any help.

## Contact

E-mail: <pete@petejon.es> Twitter:
<a href="https://twitter.com/pj_mcr">@pj_mcr</a>

## License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This
work is licensed under a
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative
Commons Attribution-NonCommercial-ShareAlike 4.0 International
License</a>.
