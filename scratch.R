df = read.csv("./superstore.csv")
head(df)
summary(df)

library(plotly)
library(dplyr)

unique(df$Category)
df_tech = df %>% filter(Category == "Technology")
df_tech = aggregate(df_tech[, 18:21], list(df_tech$State), mean)

state_codes = read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv")[,1:2]
df_tech$Group.1

dff = merge(x=df_tech, y=state_codes, by.x= "Group.1", by.y = "state")
dff

dff$hover <- with(dff, paste(Group.1, '<br>', "Profits: ", Profit))
# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa')
)

fig <- plot_ly(type="choropleth", locations=dff$code, 
               locationmode="USA-states", text = dff$hover,
               z=dff$Profit) %>% layout(geo=g)
fig <- fig %>% colorbar(title = "Profits USD")
fig <- fig %>% layout(
  title = 'Average Profits'
)

fig
