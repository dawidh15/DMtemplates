#' APAreport
#'
#' Format for creating a technical report. Adapted
#' from
#' \href{http://www.LaTeXTemplates.com}{http://www.LaTeXTemplates.com}.
#' By  Peter Wilson (herries.press@earthlink.net). Under licence CC BY-NC-SA 3.0 \href{http://creativecommons.org/licenses/by-nc-sa/3.0/}{http://creativecommons.org/licenses/by-nc-sa/3.0/},
#' It also inherits parameters from \code{pdf_document2} from \pkg{bookdown}, by Yihui Xie et al., released under license GPL-3. Most of preamble is based on the \code{latex.default} from \pkg{rmarkdown}. You may want to check the basics of templates \href{here}{http://ismayc.github.io/ecots2k16/template_pkg/} the \href{default.latex}{https://github.com/rstudio/rticles/blob/master/inst/rmarkdown/templates/ctex/resources/default.latex}.
#'
#' @inheritParams bookdown::pdf_document2
#' @param ... Arguments to \code{bookdown::pdf_document2}
#'
#' @param  toc Logic variable indicating if Table of Contents should be included. Type it in YAML header.
#'
#' @param year Is the year of the publication. Its calculated from the function \code{Sys.time}. Type it in YAML header.
#'
#' @param publisher The publisher of the document.Type it in YAML header.
#'
#' @param preamble Latex preamble if you wish to include further features to the template. Type it in YAML header.
#'
#' @param fancyHeader Logic Variable indicating if fancy header, from \code{fancyhdr} Latex package, should be used. Default TRUE. Type it in YAML header.
#' @param latex_engine Inherit from \code{bookdown::pdf_document2}. Change the default to Xelatex
#'
#' @return R Markdown output format to pass to
#'   \code{\link[rmarkdown:render]{render}}
#'
#' @examples
#'
#' \dontrun{
#' library(rmarkdown)
#' draft("MyArticle.Rmd", template = "APAreport", package = "DMtemplates")
#' }
#'@importFrom bookdown pdf_document2
#'
#'@export
APAreport <- function(toc = TRUE,
                      year,
                      publisher="PUBLISHER",
                      preamble,
                      fancyHeader,
                      latex_engine="xelatex"
                      ) {

  # get the locations of resource files located within the package
  templateLatex <- system.file( "rmarkdown/templates/reportAPA/resources/template.tex",package = "DMtemplates",mustWork = TRUE)

  # call the base html_document function
  bookdown::pdf_document2(
    toc=toc,
    template=templateLatex,
    keep_tex=TRUE,
    latex_engine=latex_engine)
}
