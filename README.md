<!-- README.md is generated from README.Rmd. Please edit that file -->




# uscenpops <img src="man/figures/hex-uscenpops.png" align="right" width="240">


<!-- badges: start -->
[![Travis build status](https://travis-ci.org/kjhealy/uscenpops.svg?branch=master)](https://travis-ci.org/kjhealy/uscenpops)
<!-- badges: end -->

This package provides a single dataset of censal and intercensal population estimates for the United States by year of age and sex, for every year from 1900 to 2019. 

## Installation

`uscenpops` is a data package. 

### Install direct from GitHub

You can install the beta version of uscenpops from [GitHub](https://github.com/kjhealy/uscenpops) with:


```r
devtools::install_github("kjhealy/uscenpops")
```

### Installation using `drat`

While using `install_github()` works just fine, it would be nicer to be able to just type `install.packages("uscenpops")` or `update.packages("uscenpops")` in the ordinary way. We can do this using Dirk Eddelbuettel's [drat](http://eddelbuettel.github.io/drat/DratForPackageUsers.html) package. Drat provides a convenient way to make R aware of package repositories other than CRAN.

First, install `drat`:


```r
if (!require("drat")) {
    install.packages("drat")
    library("drat")
}
```

Then use `drat` to tell R about the repository where `uscenpops` is hosted:


```r
drat::addRepo("kjhealy")
```

You can now install `uscenpops`:


```r
install.packages("uscenpops")
```

To ensure that the `uscenpops` repository is always available, you can add the following line to your `.Rprofile` or `.Rprofile.site` file:


```r
drat::addRepo("kjhealy")
```

With that in place you'll be able to do `install.packages("uscenpops")` or `update.packages("uscenpops")` and have everything work as you'd expect. 

Note that the drat repository only contains data packages that are not on CRAN, so you will never be in danger of grabbing the wrong version of any other package.


## Loading the data

The package works best with the [tidyverse](http://tidyverse.org/) libraries.


```r
library(tidyverse)
```

Load the data:


```r
library(uscenpops)
```


```r
uscenpops
#> # A tibble: 10,520 x 5
#>     year   age     pop   male female
#>    <int> <dbl>   <dbl>  <dbl>  <dbl>
#>  1  1900     0 1811000 919000 892000
#>  2  1900     1 1835000 928000 907000
#>  3  1900     2 1846000 932000 914000
#>  4  1900     3 1848000 932000 916000
#>  5  1900     4 1841000 928000 913000
#>  6  1900     5 1827000 921000 906000
#>  7  1900     6 1806000 911000 895000
#>  8  1900     7 1780000 899000 881000
#>  9  1900     8 1750000 884000 866000
#> 10  1900     9 1717000 868000 849000
#> # … with 10,510 more rows
```

## Example



```r

library(dplyr)
library(ggplot2)

pop_pyr <- uscenpops %>% select(year, age, male, female) %>%
  pivot_longer(male:female, names_to = "group", values_to = "count") %>%
  group_by(year, group) %>%
  mutate(total = sum(count), 
         pct = (count/total)*100, 
         base = 0) 

pop_pyr
#> # A tibble: 21,040 x 7
#> # Groups:   year, group [240]
#>     year   age group   count    total   pct  base
#>    <int> <dbl> <chr>   <dbl>    <dbl> <dbl> <dbl>
#>  1  1900     0 male   919000 38867000  2.36     0
#>  2  1900     0 female 892000 37227000  2.40     0
#>  3  1900     1 male   928000 38867000  2.39     0
#>  4  1900     1 female 907000 37227000  2.44     0
#>  5  1900     2 male   932000 38867000  2.40     0
#>  6  1900     2 female 914000 37227000  2.46     0
#>  7  1900     3 male   932000 38867000  2.40     0
#>  8  1900     3 female 916000 37227000  2.46     0
#>  9  1900     4 male   928000 38867000  2.39     0
#> 10  1900     4 female 913000 37227000  2.45     0
#> # … with 21,030 more rows
```


```r

## Axis labels
mbreaks <- c("1M", "2M", "3M")

## colors
pop_colors <- c("#E69F00", "#0072B2")

## In-plot year labels
dat_text <- data.frame(
  label =  c(seq(1900, 2015, 5), 2019),
  year  =  c(seq(1900, 2015, 5), 2019),
  age = rep(95, 25), 
  count = rep(-2.75e6, 25)
)

pop_pyr$count[pop_pyr$group == "male"] <- -pop_pyr$count[pop_pyr$group == "male"]

p <- pop_pyr %>% 
  filter(year %in% c(seq(1900, 2015, 5), 2019)) %>%
  ggplot(mapping = aes(x = age, ymin = base,
                       ymax = count, fill = group))

p + geom_ribbon(alpha = 0.9, color = "black", size = 0.1) +
  geom_label(data = dat_text, 
             mapping = aes(x = age, y = count, 
                           label = label), inherit.aes = FALSE, 
             vjust = "inward", hjust = "inward",
             fontface = "bold", 
             color = "gray40", 
             fill = "gray95") + 
  scale_y_continuous(labels = c(rev(mbreaks), "0", mbreaks), 
                     breaks = seq(-3e6, 3e6, 1e6), 
                     limits = c(-3e6, 3e6)) + 
  scale_x_continuous(breaks = seq(10, 100, 10)) +
  scale_fill_manual(values = pop_colors, labels = c("Females", "Males")) + 
  guides(fill = guide_legend(reverse = TRUE)) +
  labs(x = "Age", y = "Population in Millions",
       title = "Age Distribution of the U.S. Population, 1900-2019",
       subtitle = "Age is top-coded at 75 until 1939, at 85 until 1979, and at 100 since then",
       caption = "Kieran Healy / kieranhealy.org / Data: US Census Bureau.",
       fill = "") +
  theme(legend.position = "bottom",
        plot.title = element_text(size = rel(2), face = "bold"),
        strip.background = element_blank(),  
        strip.text.x = element_blank()) +
  coord_flip() + 
  facet_wrap(~ year, ncol = 5)
```

<img src="man/figures/README-example-2-1.png" title="plot of chunk example-2" alt="plot of chunk example-2" width="100%" />

## Source

The data are sourced from the [US Census Bureau](http://census.gov), from the residential estimates available in various formats and spans at <https://www2.census.gov/programs-surveys/popest/tables/>. In any year where multiple months were available, the July estimate was used. 

## Similar Packages

- Neal Grantham's [uspops](https://github.com/nsgrantham/uspops) contains _total_ annual population estimates from 1900 to 2018 as well as _state total_ annual estimates over the same period. 
