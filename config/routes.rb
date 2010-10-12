ActionController::Routing::Routes.draw do |map|

  map.resources :fees

  map.resources :shipping_options

  map.resources :packaging_options

  map.resources :customers do |customer|
    customer.resources :customer_payments
  end

  map.resources :orders do |order|
    order.resources :order_items
  end

  map.namespace :publish do |publish|
    publish.resources :publishers do |publisher|
      publisher.resources :catalogs do |catalog|
        catalog.resources :products
      end
      publisher.resources :products do |product|
        product.resources :items
      end
      publisher.resources :sales
      publisher.resources :publisher_payments, :as => :payments
    end
    publish.resources :items
    publish.resources :products
  end

  # remove non-nested resources once authentication is worked out
  map.namespace :retail do |retail|
    retail.resources :catalogs, :only => [:index, :show] do |catalog|
      catalog.resources :products, :only => :show
    end
    retail.resources :products, :only => :show
    retail.resources :items
  end

  map.namespace :admin do |admin|
    admin.resources :wholesale_prices
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

