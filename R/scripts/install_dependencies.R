required_packages <- c(
  # Data manipulation and visualization
  "tidyverse",
  "ggplot2",
  "dplyr",
  "gridExtra",
  "usmap",
  "sf",
  "moments",
  "brms",
  "tidybayes",
  "bayesplot",
  "sn",
  "lmtest",
  "car",
  "MASS",
  "here",
  "patchwork",
  "tinytex"  
)

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing ", pkg)
    install.packages(pkg, dependencies = TRUE)
  } else {
    message(pkg, " is already installed")
  }
}

message("Installing required packages...")
invisible(sapply(required_packages, install_if_missing))

message("\nVerifying package installations...")
for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    message(pkg, " ✓")
  } else {
    message(pkg, " ✗ (Installation failed)")
  }
}

# Install TinyTeX if not already installed
if (!tinytex::is_tinytex()) {
  message("\nInstalling TinyTeX for PDF output...")
  tinytex::install_tinytex()
  message("TinyTeX installation complete")
} else {
  message("\nTinyTeX is already installed")
}

message("\nAll dependencies have been installed. You can now run the notebooks.") 