% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rgsets.R
\docType{data}
\name{rgsets}
\alias{rgsets}
\title{Relational genesets}
\format{An object of class \code{R6ClassGenerator} of length 24.}
\usage{
rgsets
}
\description{
Relational genesets
}
\section{Arguments}{

\describe{
  \item{gsets}{A list of genesets where list names refers to geneset
  labels and values are geneset members represented as a vector}
  \item{nodes}{A data frame of labeled nodes e.g.
    \cr
    \tabular{rrrr}{
      \tab label\cr
      G1 \tab Geneset 1 \tab\cr
      G2 \tab Geneset 2 \tab\cr
      G3 \tab Geneset 3 \tab\cr
    }
  }
  \item{edges}{A data frame of directed edges
    \cr
    \tabular{rrrr}{
      from \tab to\cr
      G1 \tab G2 \tab\cr
      G1 \tab G3 \tab\cr
    }
  }
}
}

\section{Methods}{


\code{print(rgsets)} shows some information about the object data

\code{rgsets$subset(labels)} returns an rgsets object subsetted
on geneset labels
}

\section{See Also}{


\code{pvector}
}

\examples{
testdat <- readRDS(file.path(system.file("extdata", package="hypeR"), "testdat.rds"))
rgsets_obj <- rgsets$new(gsets=testdat$gsets,
                         nodes=testdat$nodes,
                         edges=testdat$edges)

}
\keyword{datasets}
