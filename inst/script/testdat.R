library(magrittr)

# Defining signatures
get_signature <- function() {
    sample(LETTERS, 8, replace=FALSE)
}
get_experiment <- function() {
    list("Signature 1" = get_signature(),
         "Signature 2" = get_signature(),
         "Signature 3" = get_signature())
}
get_project <- function() {
    list("Experiment 1" = get_experiment(),
         "Experiment 2" = get_experiment(),
         "Experiment 3" = get_experiment())
}

set.seed(0)
testdat <- list(signature = get_signature(),
                experiment = get_experiment(),
                project = get_project())

# Defining relational gsets
leaf.id <- paste("G", 1:10, sep="")
leaf.label <- paste("Leaf Geneset", 1:10, sep=" ")
internal.id <- paste("G", 11:15, sep="")
internal.label <- paste("Internal Geneset", 11:15, sep=" ")

set.seed(1)
gsets <- as.list(leaf.label) %>%
         set_names(leaf.label) %>%
         lapply(function(x) {
             size <- sample(c(10:15), 1)
             return(sample(LETTERS, size, replace=FALSE))
         })

nodes <- data.frame(list("label"=c(leaf.label, internal.label)), stringsAsFactors=FALSE) %>%
         set_rownames(c(leaf.id, internal.id))

edges <- "G13,G10
          G13,G12
          G13,G14
          G12,G7
          G12,G11
          G12,G9
          G11,G8
          G14,G3
          G14,G15
          G15,G5" %>%
          read.csv(text=., 
                   col.names=c("from", "to"),
                   header=FALSE,
                   strip.white=TRUE,
                   stringsAsFactors=FALSE)

testdat$gsets <- gsets
testdat$nodes <- nodes
testdat$edges <- edges
testdat$rgsets <- rgsets$new(gsets, nodes, edges)
saveRDS(testdat, file.path(system.file("extdata", package="hypeR"), "testdat.rds"))
