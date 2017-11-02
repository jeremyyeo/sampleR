# URLs
# add to cart: https://www.wetanz.com/ajax/add-to-cart
# get cart products: https://www.wetanz.com/ajax/get-cart-products
# save cart: https://www.wetanz.com/ajax/save-cart
# 

library(httr)

page <- httr::GET("https://www.wetanz.com/")

httr::POST(
  "https://www.wetanz.com/ajax/add-to-cart",
  body = list(id = 841)
)

resp <- httr::POST("https://www.wetanz.com/ajax/get-cart-products")

x <- content(resp)
