df = read.csv("./superstore.csv")
head(df)
summary(df)

library(plotly)
library(dplyr)


df_tech = df %>% filter(Category == "Technology")
df_tech = aggregate(df_tech[, 18:21], list(df_tech$State), mean)

state_codes = read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv")[,1:2]
df_tech$Group.1

dff = merge(x=df_tech, y=state_codes, by.x= "Group.1", by.y = "state")
dff

fig = plot_ly(df_tech, type='choropleth', locations=df_tech$Group.1, z=df_tech$Profit, text=df_tech$Group.1, colorscale="Blues")
fig


# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa')
)

fig <- plot_geo(dff, locationmode = 'USA-states')
fig <- fig %>% add_trace(
  z = ~Profit, text = ~Profit, locations = ~code,
  color = ~Profit, colorscale="Viridis",
)
fig <- fig %>% colorbar(title = "Average Profit in $")
fig <- fig %>% layout(
  title = 'Profits',
  geo = g
)
fig
