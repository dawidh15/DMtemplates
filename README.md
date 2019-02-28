# DMtemplates

This R package contains basic APA rules for technical reports or articles. 

 The template for the title page has been downloaded (and then modified) from:
 http://www.LaTeXTemplates.com

 Original author:
 Peter Wilson (herries.press@earthlink.net)

 License:
 CC BY-NC-SA 3.0 (http://creativecommons.org/licenses/by-nc-sa/3.0/)

 The template.tex (for integration with rmarkdown) is heavily based on  'default.latex' template extracted from the package "rticles". Package "rticles" is licensed under: GPL-3
 See https://github.com/rstudio/rticles/blob/master/DESCRIPTION

## Instructions for using this template:
  
Install using:

```
devtools::install_github('dawidh15/DMtemplates')
```

Then click on File--> New --> Rmarkdown.  On the pop-un window go to *from template*, and then click on *Reporte APA*. Choose a name for the folder and edit the template.

Compile using `Knitr`. You'll need an instalation of Latex, such as Miktex or TexLive. Is recommended to install a Latex distribution using the **tinytex** R package.
