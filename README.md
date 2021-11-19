# text2df

A simple R package for working with text data. Mostly a wrapper for the
`corpus`, `quanteda` & `udpipe` packages. Mostly some thoughts. An
attempt at a uniform framework.

## Demo

``` r
devtools::install_github("jaytimm/text2df")
```

### Some data

``` r
library(tidyverse)
pmids <- PubmedMTK::pmtk_search_pubmed(search_term = 'Psilocybin', 
                                       fields = c('TIAB','MH'))
```

    ## [1] "Psilocybin[TIAB] OR Psilocybin[MH]: 1215 records"

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

| doc_id     | text                                                                                                                                                                                                                                                                                       |
|:-----------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 34791625.1 | Therapeutic deficiencies with monoaminergic antidepressants invites the need to identify and develop novel rapid-acting antidepressants.                                                                                                                                                   |
| 34791625.2 | Hitherto, ketamine and esketamine are identified as safe, well-tolerated rapid-acting antidepressants in adults with treatment-resistant depression, and also mitigate measures of suicidality.                                                                                            |
| 34791625.3 | Psilocybin is a naturally occurring psychoactive alkaloid and non-selective agonist at many serotonin receptors, especially at serotonin 5-HT2A receptors, and is found in the Psilocybe genus of mushrooms.                                                                               |
| 34791625.4 | Preliminary studies with psilocybin have shown therapeutic promise across diverse populations including major depressive disorder.                                                                                                                                                         |
| 34791625.5 | The pharmacodynamic mechanisms mediating the antidepressant and psychedelic effects of psilocybin are currently unknown but are thought to involve the modulation of the serotonergic system, primarily through agonism at the 5-HT2A receptors and downstream changes in gene expression. |
| 34791625.6 | It is also established that indirect effects on dopaminergic and glutamatergic systems are contributory, as well as effects at other lower affinity targets.                                                                                                                               |

### tif2token

``` r
x1 <- corpus %>% 
  text2df::tif2sentence() %>%
  text2df::tif2token()

x1[c(4, 10)]
```

    ## $`34791625.4`
    ##  [1] "Preliminary" "studies"     "with"        "psilocybin"  "have"       
    ##  [6] "shown"       "therapeutic" "promise"     "across"      "diverse"    
    ## [11] "populations" "including"   "major"       "depressive"  "disorder"   
    ## [16] "."          
    ## 
    ## $`34784024.1`
    ##  [1] "Obsessive-compulsive" "disorder"             "("                   
    ##  [4] "OCD"                  ")"                    "is"                  
    ##  [7] "a"                    "highly"               "prevalent"           
    ## [10] "and"                  "disabling"            "condition"           
    ## [13] "for"                  "which"                "currently"           
    ## [16] "available"            "treatments"           "are"                 
    ## [19] "insufficiently"       "effective"            "and"                 
    ## [22] "alternatives"         "merit"                "priority"            
    ## [25] "attention"            "."

### token2mwe

``` r
library(PubmedMTK)
data("pmtk_tbl_mesh")
psych <- subset(pmtk_tbl_mesh, cats == 'Psychiatry and Psychology')
mw_psych <- subset(psych, grepl(' ', TermName) & !grepl(',', TermName))$TermName
sample(mw_psych, 10)
```

    ##  [1] "conflict resolutions"                
    ##  [2] "animal communications"               
    ##  [3] "patient participation rate"          
    ##  [4] "rapid eye movement sleep parasomnias"
    ##  [5] "mood incongruent hallucinations"     
    ##  [6] "patient non-compliance"              
    ##  [7] "sleep state misperception"           
    ##  [8] "biologic psychiatry"                 
    ##  [9] "involutional paraphrenias"           
    ## [10] "post-ictal amnesias"

``` r
x10 <- corpus %>% 
  text2df::tif2sentence() %>%
  text2df::tif2token() %>%
  text2df::token2mwe(mwe = mw_psych)

x10[c(4, 10)]
```

    ## $`34791625.4`
    ##  [1] "Preliminary"               "studies"                  
    ##  [3] "with"                      "psilocybin"               
    ##  [5] "have"                      "shown"                    
    ##  [7] "therapeutic"               "promise"                  
    ##  [9] "across"                    "diverse"                  
    ## [11] "populations"               "including"                
    ## [13] "major_depressive_disorder" "."                        
    ## 
    ## $`34784024.1`
    ##  [1] "Obsessive-compulsive_disorder" "("                            
    ##  [3] "OCD"                           ")"                            
    ##  [5] "is"                            "a"                            
    ##  [7] "highly"                        "prevalent"                    
    ##  [9] "and"                           "disabling"                    
    ## [11] "condition"                     "for"                          
    ## [13] "which"                         "currently"                    
    ## [15] "available"                     "treatments"                   
    ## [17] "are"                           "insufficiently"               
    ## [19] "effective"                     "and"                          
    ## [21] "alternatives"                  "merit"                        
    ## [23] "priority"                      "attention"                    
    ## [25] "."

### token2df

``` r
x2 <- corpus %>% 
  text2df::tif2sentence() %>%
  text2df::tif2token() %>%
  text2df::token2mwe(mwe = mw_psych) %>%
  text2df::token2df()

x2 %>% head() %>% knitr::kable()
```

| doc_id   | token           | sentence_id | token_id |
|:---------|:----------------|:------------|---------:|
| 34791625 | Therapeutic     | 1           |        1 |
| 34791625 | deficiencies    | 1           |        2 |
| 34791625 | with            | 1           |        3 |
| 34791625 | monoaminergic   | 1           |        4 |
| 34791625 | antidepressants | 1           |        5 |
| 34791625 | invites         | 1           |        6 |

### token2annotation

``` r
setwd(locald)
udmodel <- udpipe::udpipe_load_model('english-ewt-ud-2.3-181115.udpipe')

x3 <- corpus %>% 
  text2df::tif2sentence() %>%
  text2df::tif2token() %>%
  text2df::token2mwe(mwe = mw_psych) %>%
  text2df::token2annotation(model = udmodel)

x3 %>% head() %>% knitr::kable()
```

| doc_id   | sentence_id | start | end | term_id | token_id | token           | lemma          | upos | xpos |
|:---------|------------:|------:|----:|--------:|:---------|:----------------|:---------------|:-----|:-----|
| 34791625 |           1 |     1 |  11 |       1 | 1        | Therapeutic     | Therapeutic    | ADJ  | JJ   |
| 34791625 |           1 |    13 |  24 |       2 | 2        | deficiencies    | deficiency     | NOUN | NNS  |
| 34791625 |           1 |    26 |  29 |       3 | 3        | with            | with           | ADP  | IN   |
| 34791625 |           1 |    31 |  43 |       4 | 4        | monoaminergic   | monoaminergic  | ADJ  | JJ   |
| 34791625 |           1 |    45 |  59 |       5 | 5        | antidepressants | antidepressant | NOUN | NNS  |
| 34791625 |           1 |    61 |  67 |       6 | 6        | invites         | invite         | AUX  | VBZ  |
