% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{demo_tag}
\alias{demo_tag}
\title{Get that tag!}
\usage{
demo_tag(str)
}
\arguments{
\item{str}{A 'roxygen2' tag string.}
}
\value{
A \code{\link[roxygen2:roxy_tag]{roxygen2::roxy_tag()}}.
}
\description{
Tools for inspecting \code{\link[roxygen2:roxy_tag]{roxygen2::roxy_tag()}}s. This can be helpful for
exploring the intermediate tag objects. For example, you can use this
function to generate a tag and explore the named values in \verb{$val}.
}
\examples{
demo_tag("@param var abc")

}
