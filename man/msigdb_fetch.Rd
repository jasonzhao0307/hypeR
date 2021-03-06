% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/msigdb.R
\name{msigdb_fetch}
\alias{msigdb_fetch}
\title{Fetch gsets from msigdb}
\usage{
msigdb_fetch(msigdb_path, symbol = c("C1", "C2.CGP", "C2.CP",
  "C2.CP.BIOCARTA", "C2.CP.KEGG", "C2.CP.REACTOME", "C3.MIR", "C3.TFT",
  "C4.CGN", "C4.CM", "C5.BP", "C5.CC", "C5.MF", "C6", "C7", "H"))
}
\arguments{
\item{msigdb_path}{A list containing the gene set directory and version number of gene sets}

\item{symbol}{A symbol corresponding to a msigdb gene set}
}
\value{
A list of gene sets
}
\description{
Fetch gsets from msigdb
}
\examples{
msigdb_path <- msigdb_download_all("Homo sapiens")
REACTOME <- msigdb_fetch(msigdb_path, "C2.CP.REACTOME")

}
