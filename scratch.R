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

View(df)

ship_mode_freq = data.frame(table(df[,c("Ship.Mode")]))
ship_mode_freq

plot_ly(ship_mode_freq, labels = ~Var1, values = ~Freq, type= "pie")


state_wise_sales_average = tapply(df$Sales, df$State, mean)
df$shipping_time <-  as.Date(as.character(df$Ship.Date), format="%m/%d/%Y") - as.Date(as.character(df$Order.Date), format="%m/%d/%Y")
average_shipping_time_by_province = data.frame(tapply(df$shipping_time, df$State, mean))
average_shipping_time_by_province$state = rownames(average_shipping_time_by_province)
dff2 = merge(x=average_shipping_time_by_province, y=state_codes, by.x= "state", by.y = "state")
colnames(dff2) = c('state','avgst','code')
dff2
# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa')
)

fig <- plot_ly(type="choropleth", locations=dff2$code, 
               locationmode="USA-states", 
               #text = dff$hover,
               z=dff2$avgst) %>% layout(geo=g)
fig <- fig %>% colorbar(title = "Profits USD")
fig <- fig %>% layout(
  title = 'Average Profits'
)

fig

average_shipping_time_by_mode_of_transport = data.frame(tapply(df$shipping_time, df$Ship.Mode, mean))
average_shipping_time_by_mode_of_transport$class = rownames(average_shipping_time_by_mode_of_transport)

colnames(average_shipping_time_by_mode_of_transport) = c('timeavg', 'class')

x <- average_shipping_time_by_mode_of_transport$class
y <- average_shipping_time_by_mode_of_transport$timeavg
text <- ""
data <- data.frame(x, y, text)

fig <- plot_ly(data = data, x= ~x, y= ~y,  type = 'bar', text = text,
               marker = list(color = 'rgb(235, 190, 209)',
                             line = list(color = 'rgb(232, 76, 134)',
                                         width = 1.5)))
fig <- fig %>% layout(title = "Average Shipping Time by Mode of Transport",
                      xaxis = list(title = ""),
                      yaxis = list(title = ""))

fig
df
