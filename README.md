# Buying the Farm: The Distribution of Local and Cultural Benefits from Farmland Conservation


This repo contains data and code for Ando, Nyanzu and Parthum (2021), "[Buying the Farm: The Distribution of Local and Cultural Benefits from Farmland Conservation](http://dx.doi.org/)". 

> **Abstract:** 
>  1.	Conservation and local food have values
>       - Land conservation has grown and is found to be valued
>       -	Many local areas have passed referenda to protect natural areas around them
>       -	Some urbanizing areas are working to preserve farmland as part of the visual and cultural landscape
>       -	Demand for “local food” is exploding, accelerated by COVID
>  2.	Question: what are the values of conservation and local food, and what groups of people value them the most?
>       -	Lots of concern about environmental injustice in exposure to pollution
>       -	How much of the benefits of nature conservation flow to marginalized groups? 
>       -	Which racial and ethnic groups place the most value on local food from farms vs. food that can be harvested from nature with labor but no payment? 
>       -	How does WTP for local food vary with food insecurity?
>  3.	Method question: Do stated preference methods mis-estimate values of things to marginalized people by expressing distance attributes in terms of miles when disadvantages people don’t have access to cars? We test how things change if you express distance in time to get there instead of miles.

## Replication instructions
Click on the "fork" button at the very top right of the page to create an independent copy of the repo within your own GitHub account. Alternatively, click on the green "clone or download" button just below that to download the repo to your local computer. 

Primary data collection has not yet been collected. A simulation of the analysis is conducted using `summary/summary.rmd`. This will provide a summary of the the primary estimation in the paper.

## Requirements

The analysis uses a combination of *Stata* and *R*. While *Stata* is proprietary software, *R* is free, open-source and available for download [here](https://www.r-project.org/). The experiment design is created in *Stata* using the [DCREATE](https://ideas.repec.org/c/boc/bocode/s458059.html) package (Hole 2015), the analysis is performed using *R* using the [GMNL](https://cran.r-project.org/web/packages/gmnl/gmnl.pdf) package (Sarrias and Daziano 2017). 

## Performance

The analyses in this paper involves many computationally intensive random parameter logit estimations. The computation time for each regression ranges from 5 to 45 minutes using 4 cores with 64GB RAM.

## Problems

If any errors are discovered, please inform the owner of this repository at parthum.bryan@epa.gov. Thank you!

## License

The software code contained within this repository is made available under the [MIT license](http://opensource.org/licenses/mit-license.php). The data and figures are made available under the [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/) license.
