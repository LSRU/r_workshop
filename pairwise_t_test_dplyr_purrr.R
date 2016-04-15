library("dplyr")
library("tidyr")
library("broom")
library("purrr")
# 2 levels
df <- data.frame(value = rnorm(30), b = rep(c(rep("A", 5), rep("B", 5)), 3), cell = rep(1:2, each = 15))

df %>%
  group_by(cell) %>%
  do(tidy(t.test(value ~ b, data = .)))


by_cell <- df %>%
  group_by(cell) %>%
  nest() %>%
  mutate(model = purrr::map(data, ~ t.test(value ~ b, data = .)))

by_cell %>%
  unnest(model %>% purrr::map(tidy))

by_cell %>%
  unnest(data)

# 3 levels, pairwise
df2 <- data.frame(value = rnorm(60), b = rep(rep(c("A", "B", "C"), each = 5), 2), cell = rep(1:2, each = 15))
# do
df2 %>%
  group_by(cell) %>%
  do(tidy(pairwise.t.test(.$value, .$b)))
# purrr 
by_cell2 <- df2 %>%
  group_by(cell) %>%
  nest() %>%
  mutate(model = purrr::map(data, ~ pairwise.t.test(.$value, .$b)))
# unnest the model
by_cell2 %>%
  unnest(model %>% purrr::map(tidy))

# from Ian
# https://github.com/hadley/tibble/issues/31#issuecomment-207597557
library("purrr")

x <- list(alpha = 'horrible', beta = 'list', gamma = 'column')

x %>% map_df(~ data_frame(thing = .x), .id = "name")
x %>% Kimisc:::list_to_df() 

library("broom")
lm(mpg ~ wt + cyl, data = mtcars) %>%
  augment() %>%
  ggplot(aes(colour = factor(cyl)))+
  geom_point(aes(x = wt, y = mpg))+
  geom_line(aes(x = wt, y = .fitted))

lm(formula = Sepal.Width ~ Petal.Width + Species, data = iris) %>%
  augment() %>%
  ggplot(aes(colour = Species))+
  geom_point(aes(x = Petal.Width, y = Sepal.Width, shape = Species), colour = "black")+
  geom_point(aes(x = Petal.Width, y = .fitted))+
  geom_line(aes(x = Petal.Width, y = .fitted))

iris %>%
  gather(petal, value, starts_with("Petal")) %>%
  lm(formula = Sepal.Width ~ value + petal, data = .) %>%
  augment() %>%
  ggplot(aes(colour = petal))+
  geom_point(aes(x = value, y = Sepal.Width, shape = petal), colour = "black")+
  geom_point(aes(x = value, y = .fitted))+
  geom_line(aes(x = value, y = .fitted))

iris %>%
  gather(petal, value, starts_with("Petal")) %>%
  ggplot(aes(x = value, y = Sepal.Width, colour = petal))+
  geom_smooth(method = "lm")

  
  
