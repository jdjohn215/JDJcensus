#' table_download
#'
#' @param table a character string either of the table name or concept (consult AllVariables)
#' @param geography The geography of your data, e.g. "tract", "county", "state"
#' @param source either "acs" or "sf1"
#' @param year one of 1990, 2000, or 2010 for decennial data, or 2010-2018 for ACS data
#' @param state an optional state specification, names, postal abbreviations, and FIPS accepted
#' @param county an optional county specification, names and FIPS accepted
#'
#' @return
#' @export
#' @importFrom tidycensus get_acs
#' @importFrom tidycensus get_decennial
#'
#' @examples table_download("HISPANIC OR LATINO ORIGIN BY RACE", geography = "tract", source = "acs", year = 2018, state = "WI", county = "079")
table_download <- function(table, geography, source = "acs", year = 2018, state = NULL, county = NULL){
  # table or concept?
  table <- str_to_upper(table)
  if(table %in% AllVariables$table){
    arg.type <- "table"
  } else if(table %in% AllVariables$concept){
    arg.type <- "concept"
  } else{
    arg.type <- "not a valid variable name or concept"
  }

  # acs or decennial?
  theseVariables <- AllVariables %>%
    filter(type == str_to_lower(source))


  if(source == "acs"){
    if(arg.type == "table"){
      # get the data
      df <- suppressMessages(get_acs(geography = geography, table = table,
                                     year = year, state = state, county = county))

      # add text variable description
      df %>%
        mutate(year = year) %>%
        inner_join(select(theseVariables, variable = name, label, year))

    } else if(arg.type == "concept"){
      # get the table name for this concept
      concept.table <- unique(theseVariables$table[theseVariables$concept == table &
                                                     theseVariables$year == year])

      # get the data
      df <- suppressMessages(get_acs(geography = geography, table = concept.table,
                                     year = year, state = state, county = county))

      # add text variable description
      df %>%
        mutate(year = year) %>%
        inner_join(select(theseVariables, variable = name, label, year))

    } else{
      "not a valid variable name or concept"
    }
  } else if(source == "sf1"){
    if(arg.type == "table"){
      # get the data
      df <- suppressMessages(get_decennial(geography = geography, table = table,
                                           year = year, state = state, county = county))

      # add text variable description
      df %>%
        mutate(year = year) %>%
        inner_join(select(theseVariables, variable = name, label, year))

    } else if(arg.type == "concept"){
      # get the table name for this concept
      concept.table <- unique(theseVariables$table[theseVariables$concept == table &
                                                     theseVariables$year == year])

      # get the data
      df <- suppressMessages(get_decennial(geography = geography, table = concept.table,
                                           year = year, state = state, county = county))

      # add text variable description
      df %>%
        mutate(year = year) %>%
        inner_join(select(theseVariables, variable = name, label, year))

    } else{
      "not a valid variable name or concept"
    }
  } else{
    "source must be either 'acs' or 'sf1'"
  }


}
