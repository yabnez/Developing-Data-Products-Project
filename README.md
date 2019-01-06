# Developing-Data-Products-Project
Course Project: Shiny Application and Reproducible Pitch

This is an analysis of wholesale market statistics of vegetables and fruits at Kyoto Japan in 2017. The data consists of 
- place those foods come from
- type of food, vegetable or fruit
- month those foods received
- quantity of foods
- amount of value in Japanese Yen
- average price in Japanese Yen

The vegetables and fruits are come from all prefectures in Japan domestically, and also from imported from varieties of countries, including USA or China.

The original data is loaded from http://www.city.kyoto.lg.jp/sankan/page/0000232107.html
Before starting the Shiny analysis, 
- Originally written in Japanese, but some words are translated into English at first.
The file name is "WholesaleKyoto.csv"

When you try my Shiny codes, please download the csv file as well. We assumed the csv file is stored the current directory, but you can also modify the directory path in the code. 

When you run the app, two charts in the right hand side.
- plot data, x-axis is quantity, y-axis is average price and the size of bubble is amount.
- box plot average price for vegetable and fruit.

You can control several things in the left hand side of pop-up window.
- change the month by number in the top slider, if want to see all, select "0"
- select vegetable, fruit or both
- select the place those foods come from
- show/hide linear regression line
- show/hide boxplot
- show/hide "Adjusted R-squared" value

Enjoy it.
