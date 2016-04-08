library("googlesheets")
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("tidyr"))
suppressPackageStartupMessages(library("ggplot2"))
#devtools::install_github("hrbrmstr/ggalt")
library("ggalt")
theme_set(theme_bw(14))

# list all googlesheet
(my_sheets <- gs_ls())

# fetch results from google form
df <- gs_title("questionr") %>%
  gs_read(ws = 1)

df %>%
  mutate(week = strsplit(`Week, check when you will available`, ",")) %>%
  unnest(week) %>%
  mutate(week = trimws(week)) %>%
  count(week) %>%
  ggplot(aes(x = week, y = n))+
  #geom_bar()+
  geom_lollipop(point.colour = "steelblue", point.size = 5)+
  coord_flip()
