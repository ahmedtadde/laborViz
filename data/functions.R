# =========================================================================
# function libraries
# @description: load all libraries for project
# @return: N/A
# =========================================================================
libraries <- function(){
  library(rvest)
  library(data.table)
  library(dplyr)
  library(reshape2)
  library(shiny)
  library(ggplot2)
  library(scales)
  library(DT)
  library(markdown)
  options(warn=-1)
}




# =========================================================================
# function get_data_labor_trend
#
# @description: get data from cps url.
# @return: reshaped dataframe of labor over time
# =========================================================================
get_labor_trend <- function() {
    url <- "http://www.bls.gov/cps/cpsaat02.htm"
    
    colnames <- c(
      "year", 
      "Total Population",
      "Labor Force (Total)",
      "% Labor Force (Total)",
      "Labor Force (Employed)",
      "% Labor Force (Employed)",
      "Labor Force (Agriculture)",
      "Labor Force (Non-agriculture)",
      "Labor Force (Unemployed)",
      "% Labor Force (Unemployed)",
      "Non-Labor Force (Total)"
    )
    
    table <- url %>% 
      html() %>%
      html_nodes('table#cps_eeann_year_sex.regular')%>%html_table(header= FALSE, fill=TRUE)
    
    table <- data.table(table[[1]])
    setnames(table, colnames)
    
    table <- rbindlist(list(table[5:45][,gender:= "Men"],table[48:88][,gender:="Women"]), use.names = TRUE)
    
    table <- melt.data.table(
      table,
      id.vars = c("year", "gender"),
      variable.name = "population", 
      value.name = "value"
    )[, c("population", "value") := list(as.character(population), as.numeric(gsub(",","",value)))]
    
    return(setkeyv(table, c("year", "gender")))
}



# =========================================================================
# function get_labor_occupation
#
# @description: get data from cps url.
# @return: reshaped dataframe of employed people by age,race, gender, occupation
# =========================================================================
get_labor_occupation <- function() {
  url <- "http://www.bls.gov/cps/cpsaat14.htm"
  colnames <- c("age_group",
                "Mining/Extraction",
                "Construction",
                "Manufacturing",
                "Wholesale/Retail",
                "Transportation/Utilities",
                "Information Services",
                "Finance Services",
                "Professional/Business Services",
                "Education/Health Services",
                "Leisure Services",
                "Other Services",
                "Public Administration")
  
  table <- url %>% 
    html() %>%
    html_nodes('#cps_eeann_emp_nonag')%>%html_table(header= FALSE, fill=TRUE)
  
  table <- data.table(table[[1]])[25:dim(table[[1]])[1]][1:64]
  setnames(table, colnames)
  
  table_white <- table[2:16][age_group %in% c("16 to 19 years","20 to 24 years","25 to 54 years","55 years and over")
                             ][, race:= "White"][, gender:= rep(c("Men", "Women"), each=4)]
  
  table_black <- table[18:32][age_group %in% c("16 to 19 years","20 to 24 years","25 to 54 years","55 years and over")
                              ][, race:= "Black"][, gender:= rep(c("Men", "Women"), each=4)]
  
  table_asian <- table[34:48][age_group %in% c("16 to 19 years","20 to 24 years","25 to 54 years","55 years and over")
                              ][, race:= "Asian"][, gender:= rep(c("Men", "Women"), each=4)]
  
  table_hispanic <- table[50:64][age_group %in% c("16 to 19 years","20 to 24 years","25 to 54 years","55 years and over")
                                 ][, race:= "Hispanic"][, gender:= rep(c("Men", "Women"), each=4)]
  
  
  table <- rbindlist(list(table_white,table_black,table_asian,table_hispanic), use.names = T)
  rm(list = c("table_white","table_black", "table_asian","table_hispanic","colnames","url"))
  
  table <- melt.data.table(table, id.vars = c("age_group","race","gender"), variable.name = "occupation")
  
  table[, c("occupation","value" ):= list(as.character(occupation), as.numeric(gsub(",","",value)))
        ][,percentage:= round(value / sum(value) * 100, 2), by = list(age_group,race,gender)]
  
  return(setkey(table, age_group, race, gender,occupation))
}



# =========================================================================
# function get_labor_education
#
# @description: get data from cps url.
# @return: reshaped dataframe of employed people by education attainment
# =========================================================================
get_labor_education <- function() {
  url <- "http://www.bls.gov/cps/cpsaat07.htm"
  colnames <- c("metric",
                "Less than High School",
                "High School",
                "Some College or Associate Degree",
                "Some College No Degree",
                "Some College Associate Degree",
                "Bachelors Degree or Higher",
                "Bachelors Degree",
                "Advanced Degree"
  )
  
  table <- url %>%
    html() %>%
    html_nodes('#cps_eeann_educ')%>%html_table(header= FALSE, fill=TRUE)
  
  table <- data.table(table[[1]])[4:59]
  setnames(table, colnames)
  
  table_total <- table[2:8][,category:= "Total"]
  table_men <- table[10:16][,category:= "Men"]
  table_women <- table[18:24][,category:= "Women"]
  table_white <- table[26:32][,category:= "White"]
  table_black <- table[34:40][,category:= "Black"]
  table_asian <- table[42:48][,category:= "Asian"]
  table_hispanic <- table[50:56][,category:= "Hispanic"]
  
  table <- rbindlist(list(table_total, table_men, table_women, table_white,table_black,table_asian,table_hispanic))
  rm(list = c("table_total","table_men","table_women","table_white","table_black", "table_asian","table_hispanic","colnames","url"))
  
  table <- melt.data.table(table, id.vars = c("metric","category"), variable.name = "education")
  table[, c("education", "value"):= list(as.character(education), as.numeric(gsub(",","",value)))]
  return(setkey(table, metric, category, education))
  
}