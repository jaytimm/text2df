<!-- badges: start -->

[![R-CMD-check](https://github.com/jaytimm/text2df/workflows/R-CMD-check/badge.svg)](https://github.com/jaytimm/text2df/actions)
[![Codecov test
coverage](https://codecov.io/gh/jaytimm/text2df/branch/master/graph/badge.svg)](https://codecov.io/gh/jaytimm/text2df?branch=master)
<!-- badges: end -->

# text2df

A simple R package for working with text data. Mostly a wrapper for the
`corpus`, `quanteda` & `udpipe` packages. Mostly some thoughts. An
attempt at a uniform framework.

``` r
devtools::install_github("jaytimm/text2df")
```

### Some data

``` r
library(tidyverse)
pmids <- PubmedMTK::pmtk_search_pubmed(search_term = 'Psilocybin', 
                                       fields = c('TIAB','MH'))
```

    ## [1] "Psilocybin[TIAB] OR Psilocybin[MH]: 1262 records"

``` r
corpus <- PubmedMTK::pmtk_get_records2(pmids = pmids$pmid) %>%
  bind_rows() %>%
  filter(!is.na(abstract)) %>%
  rename(doc_id = pmid, text = abstract)
```

### tif2sentence

``` r
x0 <- corpus %>% 
  text2df::tif2sentence()

head(x0) %>% knitr::kable()
```

| doc_id     | text                                                                                                                                                                                                                                         |
|:-----------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 35103814.1 | Psychedelics, such as psilocybin represent one of the most promising current therapeutic approaches in psychiatry.                                                                                                                           |
| 35103814.2 | Psychedelics seem to have not only potent antidepressant effects.                                                                                                                                                                            |
| 35103814.3 | Do they also work particularly quickly, i.e. within one day?                                                                                                                                                                                 |
| 35103814.4 | The available literature on clinical studies of psychedelics in depressive syndromes is presented both from the period up to the prohibition of these substances in the late 1960s as well as after the resumption of research in the 2000s. |
| 35103814.5 | One focus is the speed of onset of antidepressant action.                                                                                                                                                                                    |
| 35103814.6 | Only the clinical studies published since 2016 that meet modern methodological standards have also systematically examined the speed of the antidepressant onset of action.                                                                  |

### tif2token

``` r
x1 <- corpus %>% 
  text2df::tif2sentence() %>%
  text2df::tif2token()

x1[c(1:3)]
```

    ## $`35103814.1`
    ##  [1] "Psychedelics" ","            "such"         "as"           "psilocybin"  
    ##  [6] "represent"    "one"          "of"           "the"          "most"        
    ## [11] "promising"    "current"      "therapeutic"  "approaches"   "in"          
    ## [16] "psychiatry"   "."           
    ## 
    ## $`35103814.2`
    ##  [1] "Psychedelics"   "seem"           "to"             "have"          
    ##  [5] "not"            "only"           "potent"         "antidepressant"
    ##  [9] "effects"        "."             
    ## 
    ## $`35103814.3`
    ##  [1] "Do"           "they"         "also"         "work"         "particularly"
    ##  [6] "quickly"      ","            "i.e."         "within"       "one"         
    ## [11] "day"          "?"

### token2mwe

``` r
library(PubmedMTK)
data("pmtk_tbl_mesh")

mwe <- pmtk_tbl_mesh %>%
  filter(!grepl(',', TermName)) %>%
  filter(grepl(' ', TermName)) %>%
  distinct(TermName, .keep_all = T) 

sample(mwe$TermName, size = 10)
```

    ##  [1] "mometasone furoate formoterol fumarate drug combination"
    ##  [2] "pibids syndrome"                                        
    ##  [3] "raw food"                                               
    ##  [4] "sublingual gland neoplasms"                             
    ##  [5] "medical device safety"                                  
    ##  [6] "helper viruses"                                         
    ##  [7] "hze particle"                                           
    ##  [8] "bonin islands"                                          
    ##  [9] "cosmetic reconstructive surgery"                        
    ## [10] "anal sacs"

``` r
x10 <- corpus %>% 
  text2df::tif2sentence() %>%
  text2df::tif2token() %>%
  text2df::token2mwe(mwe = mwe$TermName)

x10[c(1:3)]
```

    ## $`35103814.1`
    ##  [1] "Psychedelics" ","            "such"         "as"           "psilocybin"  
    ##  [6] "represent"    "one"          "of"           "the"          "most"        
    ## [11] "promising"    "current"      "therapeutic"  "approaches"   "in"          
    ## [16] "psychiatry"   "."           
    ## 
    ## $`35103814.2`
    ##  [1] "Psychedelics"   "seem"           "to"             "have"          
    ##  [5] "not"            "only"           "potent"         "antidepressant"
    ##  [9] "effects"        "."             
    ## 
    ## $`35103814.3`
    ##  [1] "Do"           "they"         "also"         "work"         "particularly"
    ##  [6] "quickly"      ","            "i.e."         "within"       "one"         
    ## [11] "day"          "?"

### token2df

``` r
x2 <- corpus %>% 
  text2df::tif2sentence() %>%
  text2df::tif2token() %>%
  text2df::token2mwe(mwe = mwe$TermName) %>%
  text2df::token2df()

x2 %>% head() %>% knitr::kable()
```

| doc_id   | token        | sentence_id | token_id | term_id |
|:---------|:-------------|:------------|---------:|--------:|
| 35103814 | Psychedelics | 1           |        1 |       1 |
| 35103814 | ,            | 1           |        2 |       2 |
| 35103814 | such         | 1           |        3 |       3 |
| 35103814 | as           | 1           |        4 |       4 |
| 35103814 | psilocybin   | 1           |        5 |       5 |
| 35103814 | represent    | 1           |        6 |       6 |

### token2annotation

``` r
setwd(locald)
udmodel <- udpipe::udpipe_load_model('english-ewt-ud-2.3-181115.udpipe')

x3 <- corpus %>% 
  text2df::tif2sentence() %>%
  text2df::tif2token() %>%
  text2df::token2mwe(mwe = mwe$TermName) %>%
  text2df::token2annotation(model = udmodel)

x3 %>% head() %>% knitr::kable()
```

| doc_id   | sentence_id | start | end | term_id | token_id | token        | lemma       | upos  | xpos | feats                              |
|:---------|------------:|------:|----:|--------:|:---------|:-------------|:------------|:------|:-----|:-----------------------------------|
| 35103814 |           1 |     1 |  12 |       1 | 1        | Psychedelics | Psychedelic | NOUN  | NNS  | Number=Plur                        |
| 35103814 |           1 |    14 |  14 |       2 | 2        | ,            | ,           | PUNCT | ,    | NA                                 |
| 35103814 |           1 |    16 |  19 |       3 | 3        | such         | such        | ADJ   | JJ   | Degree=Pos                         |
| 35103814 |           1 |    21 |  22 |       4 | 4        | as           | as          | ADP   | IN   | NA                                 |
| 35103814 |           1 |    24 |  33 |       5 | 5        | psilocybin   | psilocybin  | NOUN  | NN   | Number=Sing                        |
| 35103814 |           1 |    35 |  43 |       6 | 6        | represent    | represent   | VERB  | VBD  | Mood=Ind\|Tense=Past\|VerbForm=Fin |
