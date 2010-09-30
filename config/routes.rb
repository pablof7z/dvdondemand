ActionController::Routing::Routes.draw do |map|
  map.devise_for :users

  map.resources :fees

  map.resources :shipping_options

  map.resources :packaging_options

  map.resources :customers do |customer|
    customer.resources :customer_payments
  end

  map.resources :orders do |order|
    order.resources :order_items
  end

  map.resources :publishers do |publisher|
    publisher.resources :catalogs do |catalog|
      catalog.resources :products
    end
    publisher.resources :products do |product|
      product.resources :items
      product.resources :wholesale_prices
    end
    publisher.resources :items
    publisher.resources :sales
    publisher.resources :publisher_payments
  end
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
