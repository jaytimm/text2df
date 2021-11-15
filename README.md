## text2df

A simple R package for reshaping text data.

``` r
library(tidyverse)
pmids <- PubmedMTK::pmtk_search_pubmed(search_term = 'Psilocybin', 
                                       fields = c('TIAB','MH'))
```

    ## [1] "Psilocybin[TIAB] OR Psilocybin[MH]: 1209 records"

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

| doc_id     | text                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|:-----------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 34750350.1 | Psilocybin has shown promise for the treatment of mood disorders, which are often accompanied by cognitive dysfunction including cognitive rigidity.                                                                                                                                                                                                                                                                                                                                                                               |
| 34750350.2 | Recent studies have proposed neuropsychoplastogenic effects as mechanisms underlying the enduring therapeutic effects of psilocybin.                                                                                                                                                                                                                                                                                                                                                                                               |
| 34750350.3 | In an open-label study of 24 patients with major depressive disorder, we tested the enduring effects of psilocybin therapy on cognitive flexibility (perseverative errors on a set-shifting task), neural flexibility (dynamics of functional connectivity or dFC via functional magnetic resonance imaging), and neurometabolite concentrations (via magnetic resonance spectroscopy) in brain regions supporting cognitive flexibility and implicated in acute psilocybin effects (e.g., the anterior cingulate cortex, or ACC). |
| 34750350.4 | Psilocybin therapy increased cognitive flexibility for at least 4 weeks post-treatment, though these improvements were not correlated with the previously reported antidepressant effects.                                                                                                                                                                                                                                                                                                                                         |
| 34750350.5 | One week after psilocybin therapy, glutamate and N-acetylaspartate concentrations were decreased in the ACC, and dFC was increased between the ACC and the posterior cingulate cortex (PCC).                                                                                                                                                                                                                                                                                                                                       |
| 34750350.6 | Surprisingly, greater increases in dFC between the ACC and PCC were associated with less improvement in cognitive flexibility after psilocybin therapy.                                                                                                                                                                                                                                                                                                                                                                            |

### tif2token

``` r
x1 <- corpus %>% 
  text2df::tif2sentence() %>%
  text2df::tif2token()

x1[[99]]
```

    ##  [1] "We"                   "manually"             "reviewed"            
    ##  [4] "resulting"            "grants"               "to"                  
    ##  [7] "determine"            "whether"              "they"                
    ## [10] "directly"             "funded"               "psychedelic-assisted"
    ## [13] "therapy"              "clinical"             "trials"              
    ## [16] "."

### token2df

``` r
x2 <- corpus %>% 
  text2df::tif2sentence() %>%
  text2df::tif2token() %>%
  text2df::token2df()

x2 %>% head() %>% knitr::kable()
```

| doc_id   | token      | sentence_id | token_id |
|:---------|:-----------|:------------|---------:|
| 34750350 | Psilocybin | 1           |        1 |
| 34750350 | has        | 1           |        2 |
| 34750350 | shown      | 1           |        3 |
| 34750350 | promise    | 1           |        4 |
| 34750350 | for        | 1           |        5 |
| 34750350 | the        | 1           |        6 |
