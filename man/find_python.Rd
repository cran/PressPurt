% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helper_funcs.R
\name{find_python}
\alias{find_python}
\title{Find Python versions, Conda, & Virtual Environments}
\usage{
find_python(python = TRUE, conda = TRUE, virtualenv = TRUE)
}
\arguments{
\item{python}{If TRUE will list available python versions.
Default: TRUE}

\item{conda}{If TRUE will list available conda environments.
Default: TRUE}

\item{virtualenv}{If TRUE will list available virtual environments.
Default: TRUE}
}
\value{
None
}
\description{
This function lists available python versions, conda
environments, and virtual environments. One may show
all three or just one.
}
\examples{
\dontrun{
find_python()
}
}
