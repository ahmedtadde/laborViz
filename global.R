# =========================================================================
# Load libraries and scripts
# =========================================================================
source("data/functions.R")
libraries

# =========================================================================
# GET parsed data from parser.R script into dataframes
# =========================================================================
dataframes <- list(
    trend = get_labor_trend(),
    occupation = get_labor_occupation(),
    education = get_labor_education()
  )


# =========================================================================
# ui.R variables
# =========================================================================
choices <- list(
    category = c("Gender", "Race"),
    trend_year = unique(dataframes$trend$year),
    trend_population = unique(dataframes$trend$population),
    occupation_age_group = unique(dataframes$occupation$age_group),
    occupation_race = unique(dataframes$occupation$race),
    occupation_occupation = unique(dataframes$occupation$occupation),
    education_metric = unique(dataframes$education$metric),
    education_category = unique(dataframes$education$category),
    education_education = unique(dataframes$education$education)
)


# =========================================================================
# server.R variables and functions
# =========================================================================
CATEGORYCOLORS <- c("Men" = "#4393C3",
                    "Women"="#D6604D",
                    "White"="#1f77b4",
                    "Asian"="#ff7f0e",
                    "Hispanic"="#2ca02c",
                    "Black"="#d62728")