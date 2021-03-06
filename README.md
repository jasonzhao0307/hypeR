
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hypeR

[![](https://img.shields.io/badge/bioconductor-3.9-3a6378.svg)](https://doi.org/doi:10.18129/B9.bioc.hypeR)
[![](https://img.shields.io/badge/platforms-linux%20%7C%20osx%20%7C%20win-2a89a1.svg)](https://bioconductor.org/checkResults/3.9/bioc-LATEST/hypeR/)
[![](https://img.shields.io/badge/lifecycle-maturing-4ba598.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![](https://bioconductor.org/shields/build/devel/bioc/hypeR.svg)](https://bioconductor.org/checkResults/devel/bioc-LATEST/hypeR/)
[![](https://img.shields.io/github/last-commit/montilab/hypeR.svg)](https://github.com/montilab/hypeR/commits/master)

## Documentation

Please visit <https://montilab.github.io/hypeR-docs/>

## Installation

Install the development version of the package from Github.

``` r
devtools::install_github("montilab/hypeR")
```

Or install the development version of the package from Bioconductor.

``` r
BiocManager::install("montilab/hypeR")
```

If not using the current version of R, try installing from our dev
branch.

``` r
devtools::install_github("montilab/hypeR", ref="dev")
```

## Usage

``` r
library(hypeR)
```

#### Example of a signature

Here we define our signature of interest as a group of genes randomly
sampled from the *estrogen-dependent gene expression* gset. A signature
is simply a vector of
symbols.

``` r
signature <- readRDS(system.file("extdata/signatures.rds", package="hypeR"))$signature
```

``` r
head(signature)
```

    #> [1] "GTF2F1"    "HIST1H2AJ" "KANK1"     "STAG1"     "FKBP4"     "SMC1A"

#### Example of a geneset

Here we use a genesets example from [REACTOME](https://reactome.org/). A
geneset is simply a list of vectors, therefore, one can use any custom
geneset in their analysis, as long as it is appropriately
defined.

``` r
gsets <- readRDS(system.file("extdata/gsets.rds", package="hypeR"))$REACTOME
```

``` r
head(names(gsets))
```

    #> [1] "REACTOME_3_UTR_MEDIATED_TRANSLATIONAL_REGULATION"                        
    #> [2] "REACTOME_A_TETRASACCHARIDE_LINKER_SEQUENCE_IS_REQUIRED_FOR_GAG_SYNTHESIS"
    #> [3] "REACTOME_ABACAVIR_TRANSPORT_AND_METABOLISM"                              
    #> [4] "REACTOME_ABC_FAMILY_PROTEINS_MEDIATED_TRANSPORT"                         
    #> [5] "REACTOME_ABCA_TRANSPORTERS_IN_LIPID_HOMEOSTASIS"                         
    #> [6] "REACTOME_ABORTIVE_ELONGATION_OF_HIV1_TRANSCRIPT_IN_THE_ABSENCE_OF_TAT"

``` r
head(gsets[[1]])
```

    #> [1] "EIF1AX" "EIF2S1" "EIF2S2" "EIF2S3" "EIF3A"  "EIF3B"

#### Hyper enrichment

All workflows begin with performing hyper enrichment with ***hypeR***.
Often we are just interested in a single signature, as described above.
In this case, ***hypeR*** will return a ***hyp*** object. This object
contains relevant information to the enrichment results and is
recognized by downstream methods.

``` r
hyp_obj <- hypeR(signature, gsets, fdr=0.05)
```

#### Downstream methods

Please visit the [documentation](https://montilab.github.io/hypeR/) for
detailed functionality. Below is a brief list of some methods.

##### Downloading genesets

``` r
# Download genesets from msigdb
msigdb_path <- msigdb_download_all(species="Homo sapiens")

BIOCARTA <- msigdb_fetch(msigdb_path, "C2.CP.BIOCARTA")
KEGG     <- msigdb_fetch(msigdb_path, "C2.CP.KEGG")
REACTOME <- msigdb_fetch(msigdb_path, "C2.CP.REACTOME")
```

##### Visualize results

``` r
# Show interactive table
hyp_show(hyp_obj)

# Plot bar plot
hyp_plot(hyp_obj)

# Plot enrichment map
hyp_emap(hyp_obj)

# Plot hiearchy map
hyp_hmap(hyp_obj)
```

##### Saving results

``` r
# Save to excel
hyp_to_excel(hyp_obj, file_path="pathways.xlsx")

# Save to table
hyp_to_table(hyp_obj, file_path="pathways.txt")

# Generate markdown report
hyp_to_rmd(lmultihyp_obj,
           file_path="hyper-enrichment.rmd",
           title="Hyper Enrichment (hypeR)",
           subtitle="YAP, TNF, and TAZ Knockout Experiments",
           author="Anthony Federico, Stefano Monti",
           show_plots=T,
           show_emaps=T,
           show_hmaps=T,
           show_tables=T)
```
