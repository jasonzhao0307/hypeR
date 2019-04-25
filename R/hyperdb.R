#' Print available gene sets
#'
#' @param quiet Use true to suppress printing of available genesets
#' @return A character vector of available genesets
#'
#' @importFrom gh gh
#' @export
hyperdb_info <- function(quiet=FALSE) {
    response <- gh("/repos/:owner/:repo/contents/:path", owner="montilab", repo="hyperdb", path="data/genesets")
    files <- vapply(response, "[[", "", "name")
    gsets <- gsub(".rds", "", files)
    if (!quiet) print(gsets) 
    return(gsets)
}

#' Fetch a gene sets from hyperdb
#'
#' @param gset A name corresponding to an available gene set
#' @return A list of gene sets
#'
#' @export
hyperdb_get <- function(gset) {
    url <- "https://github.com/montilab/hyperdb/raw/master/data/genesets/{0}.rds"
    temp <- tempfile(fileext=".rds")
    httr::GET(gsub("\\{0}", gset, url), 
              .send_headers = c("Accept" = "application/octet-stream"),
              httr::write_disk(temp, overwrite=TRUE))    
    return(readRDS(temp))
}