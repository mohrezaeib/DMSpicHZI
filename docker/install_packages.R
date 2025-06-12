# install_packages.R

cran_packages <- c(
  "plumber", "reticulate", "R.utils", "XML", "magick",
  "units", "sf", "uuid", "future", "promises"
)

# Check which packages are not installed
to_install <- setdiff(cran_packages, rownames(installed.packages()))

# Install missing packages
if (length(to_install)) {
  install.packages(to_install, repos = "https://cloud.r-project.org")
}
