
#
# Run from the command line
# Arg[1]: search term, ex: "dogs"
# Arg[2]: number of videos to iterate through ex: 23
#
# Example cmd line '''   Rscript youtube_truth.R "dogs" 23   '''
#
# Note: you will need to add your R binary to your PATH to run from command line
#

args <- commandArgs(trailingOnly = TRUE)

search <- ""#args[1]

number.of.vids <- 75 #args[2]


library(RSelenium)
library(tidyverse)

# Set up
driver <- rsDriver(browser = c("chrome"))
remDr <- driver[["client"]]
#remDr$navigate(paste0("https://www.youtube.com/results?search_query=",search))
# alternativley, to start from the first suggested youtube vid, use this:
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
                             search,
                             "_",
                             number.of.vids,
                             "vids",
                             ".csv")
)

remDr$close()

