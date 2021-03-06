% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helper_funcs.R
\name{set_python_conda}
\alias{set_python_conda}
\title{Set Python Conda environment}
\usage{
set_python_conda(condaenv, verbose = TRUE)
}
\arguments{
\item{condaenv}{Specify conda environment name}

\item{verbose}{TRUE or FALSE. When TRUE, shows python and conda configuration.
Default: TRUE}
}
\value{
None
}
\description{
This function sets your conda environment.
Run this command before PreprocessMatrix. Install python dependencies in the
same conda environment that you set here.
To make a new conda environment use the create_conda_env function.
}
\examples{
\dontrun{
set_python_conda(
    condaenv = "r-reticulate", 
    verbose = TRUE)
}
}
