% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hyperdb.R
\name{hyperdb_fetch}
\alias{hyperdb_fetch}
\title{Fetch gsets from hypeR-db}
\usage{
hyperdb_fetch(gset)
}
\arguments{
\item{gset}{A name corresponding to an available gene set}
}
\value{
A list of gene sets
}
\description{
Fetch gsets from hypeR-db
}
\examples{
gsets <- hyperdb_fetch("Cancer_Cell_Line_Encyclopedia")

}
