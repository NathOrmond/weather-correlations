# MM923 Weather Analysis Project

This project analyzes weather data for the MM923 module assessment, focusing on predicting average temperatures across US cities and providing insights for travel agency decision-making.

## Project Structure

```
mm923/
├── data/
│   ├── raw/          # Original data files
│   └── processed/    # Cleaned and transformed data
├── R/
│   ├── functions.R   # Helper functions for analysis
│   └── scripts/
│       └── install_dependencies.R  # Script to install required packages
├── notebooks/        # Analysis notebooks
│   ├── 01_data_management.Rmd
│   ├── 02_data_exploration.Rmd
│   ├── 03_model_building.Rmd
│   └── 04_summary_report.Rmd
├── outputs/          # Generated visualizations
└── report/          # Final report
```

## Quick Start

1. **Install Dependencies**
   ```R
   # Run this in R console
   source("R/scripts/install_dependencies.R")
   ```
   This will install all required packages for the project.

2. **Setup**
   - Open the RStudio project file `mm923-project.Rproj`
   - The dependencies script will have installed all required packages

3. **Run Analysis**
   - Execute notebooks in numerical order:
     1. `01_data_management.Rmd`
     2. `02_data_exploration.Rmd`
     3. `03_model_building.Rmd`
     4. `04_summary_report.Rmd`
   - Each notebook will:
     - Load required packages
     - Source helper functions from `R/functions.R`
     - Process data or perform analysis
     - Save outputs to appropriate directories

## Notebooks Overview

### 1. Data Management (`01_data_management.Rmd`)
- Loads and cleans raw weather data
- Handles missing values and outliers
- Creates derived variables
- Saves processed data for subsequent analysis
- Generates data quality visualizations

### 2. Data Exploration (`02_data_exploration.Rmd`)
- Analyzes relationships between variables
- Creates exploratory visualizations
- Identifies key predictors of temperature
- Tests initial hypotheses about temperature patterns

### 3. Model Building (`03_model_building.Rmd`)
- Develops and compares regression models
- Implements variable selection methods
- Validates model assumptions
- Selects optimal model for predictions
- Saves final model for use in summary report

### 4. Summary Report (`04_summary_report.Rmd`)
- Generates final visualizations and insights
- Answers key business questions
- Provides recommendations for the travel agency
- Creates executive summary of findings

## Key Features

- **Modular Design**: Each notebook focuses on a specific aspect of the analysis
- **Reproducible**: All code and data transformations are documented
- **Automated**: Helper functions handle common tasks like saving visualizations
- **Comprehensive**: Analysis covers data cleaning, exploration, modeling, and reporting

## Dependencies

The project uses the following key R packages:
- `tidyverse` for data manipulation and visualization
- `ggplot2` for creating plots
- `usmap` for US map visualizations
- `sf` for spatial data handling
- `lmtest` and `car` for model diagnostics
- `here` for consistent file paths
- `moments` for statistical moments
- `brms` and `tidybayes` for Bayesian analysis
- `patchwork` for plot arrangement

All dependencies can be installed automatically using the `install_dependencies.R` script.

## Notes

- All visualizations are automatically saved to the `outputs/` directory
- The final model is saved as `final_model.rds` in the processed data directory
- Helper functions in `R/functions.R` are used across all notebooks
- Package dependencies are managed through `R/scripts/install_dependencies.R`