# LIBRARIES ####

library(RSelenium)
library(tidyverse)

# RSELENIUM INSTALL ISSUES ####

# If you have difficulty installing RSelenium from CRAN, try installing with Devtools:
# install.packages("devtools") 
# devtools::install_github("johndharrison/binman")
# devtools::install_github("johndharrison/wdman")
# devtools::install_github("ropensci/RSelenium")

# DEFINE FNS ####

search.vids <- function(search, number.of.vids) {
    # function that allows you to enter a search term in quotation and specify the number of vids you want it to cycle through
    # Set up
    driver <- rsDriver(browser = c("chrome"))
    remDr <- driver[["client"]]
    remDr$navigate(paste0("https://www.youtube.com/results?search_query=",search))
    Sys.sleep(2)
    
    # Create data frame to append all the titles to
    all.titles <- data.frame(Name = "Initialize")
    
    # Click on first vid
    first.vid <- remDr$findElement(using = 'xpath', value = '//*[@id="video-title"]')
    first.vid$clickElement()
    Sys.sleep(9)
    
    
    # Begin loop
    i = 1
    while (i < number.of.vids) {
      Sys.sleep(1)
      vid.title <- remDr$findElement(using = 'xpath', value = "//*[@id='container']/h1/yt-formatted-string")
      vid.title <- vid.title$getElementText() %>% as.character()
      vid.title <- data.frame(Name = vid.title)
      all.titles <- rbind(all.titles, vid.title)
      Sys.sleep(3)
      # Next vid
      remDr$sendKeysToActiveElement(list(key = "shift", "N"))
      i = i + 1
      Sys.sleep(sample(seq(7, 15, 1), 1))
    }
    
    write.csv(all.titles, paste0("C:\\Users\\XPS\\Desktop\\",
                                 gsub(pattern = ":", replacement = "_",
                                      gsub(pattern = " ", replacement = "_", Sys.time())), 
                                 search,
                                 "_",
                                 number.of.vids,
                                 "vids",
                                 ".csv")
    )
    
    remDr$close()
    paste("All done! Ran search term ",search , " ", number.of.vids, " times.")
}

start.fresh <- function(number.of.vids) {
    # function that starts with a fresh Chrome session and iterates through whatever vids Youtube recommends
    # Set up
    driver <- rsDriver(browser = c("chrome"))
    remDr <- driver[["client"]]
    remDr$navigate("https://www.youtube.com")
    Sys.sleep(2)
    
    # Create data frame to append all the titles to
    all.titles <- data.frame(Name = "Initialize")
    
    # Click on first vid
    first.vid <- remDr$findElement(using = 'xpath', value = '//*[@id="video-title"]')
    first.vid$clickElement()
    Sys.sleep(9)
    
    
    # Begin loop
    i = 1
    while (i < number.of.vids) {
      Sys.sleep(1)
      vid.title <- remDr$findElement(using = 'xpath', value = "//*[@id='container']/h1/yt-formatted-string")
      vid.title <- vid.title$getElementText() %>% as.character()
      vid.title <- data.frame(Name = vid.title)
      all.titles <- rbind(all.titles, vid.title)
      Sys.sleep(3)
      # Next vid
      remDr$sendKeysToActiveElement(list(key = "shift", "N"))
      i = i + 1
      Sys.sleep(sample(seq(7, 15, 1), 1))
    }
    
    write.csv(all.titles, paste0("C:\\Users\\XPS\\Desktop\\",
                                 gsub(pattern = ":", replacement = "_",
                                      gsub(pattern = " ", replacement = "_", Sys.time())), 
                                 "_",
                                 number.of.vids,
                                 "vids",
                                 ".csv")
    )
    
    remDr$close()
    paste("All done! Ran the first Youtube suggestion through the autosuggest ", number.of.vids, " times.")
}

search.vids.x.times <- function(search, number.of.vids, number.of.iterations) {
  # iterates through the search.vids function n number of times, for gathering empirical data
  i <- 0
  while (i < number.of.iterations) {
    search.vids(search, number.of.vids)
    i <- i + 1
    
  }
  
  paste("All done! Ran ", number.of.iterations, " iterations")
}

fresh.vids.x.times <- function(number.of.vids, number.of.iterations) {
  # iterates through the start.fresh function n number of times, for gathering empirical data
  i <- 0
  while (i < number.of.iterations) {
    start.fresh(number.of.vids)
    i <- i + 1
  }
  
  paste("All done! Ran ", number.of.iterations, " iterations")
}










