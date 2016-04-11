library("googlesheets")
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("tidyr"))
suppressPackageStartupMessages(library("ggplot2"))
#devtools::install_github("hrbrmstr/ggalt")
library("ggalt")
library("stringr")
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
  group_by(email) %>%
  count(week)

df %>%
  mutate(week = strsplit(`Week, check when you will available`, ",")) %>%
  unnest(week) %>%
  mutate(week = trimws(week)) %>%
  count(week) %>%
  ggplot(aes(x = week, y = n))+
  #geom_bar()+
  geom_lollipop(point.colour = "steelblue", point.size = 5)+
  coord_flip()

# packages
df %>%
  gather(package, value, starts_with("Did you hear")) %>% 
  group_by(package, value) %>%
  summarise (n = n()) %>%
  ungroup %>%
  mutate(package = str_extract(package, "\\[([[:alnum:]]+)\\]")) %>%
  {my_order <<- filter(., value == "Yes, using it") %>%
    arrange(n) %>%
    .$package
  .} %>% # broom has 0 usage
  mutate(package = factor(package, levels = c("[broom]", my_order))) %>%
  ggplot(aes(x = reorder(package, desc(value)), y = n, fill = value))+
  geom_bar(stat = "identity", position = "fill")+
  labs(y = "", x = "")+
  theme_minimal()+
  scale_y_discrete(expand = c(0, 0))+
  scale_fill_hue("")+
  coord_flip()

# tasks
df %>%
  gather(task, value, starts_with("Check")) %>%
  mutate(task = strsplit(value, ",")) %>%
  unnest(task) %>%
  mutate(task = trimws(task)) %>%
  group_by(task) %>%
  summarise (n = n()) %>%
  filter(!is.na(task)) %>%
  ggplot(aes(x = reorder(task, n), y = n))+
  geom_bar(stat = "identity")+
  labs(y = "", x = "")+
  theme_minimal()+
  scale_y_discrete(expand = c(0, 0))+
  scale_fill_hue("")+
  coord_flip()
