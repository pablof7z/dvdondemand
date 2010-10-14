ActionController::Routing::Routes.draw do |map|

  map.resources :fees

  map.resources :shipping_options

  map.resources :packaging_options

  map.devise_for :customers, :as => 'users'  # first to avoid the :customers resources to catch devise's auto-generated routes
  map.resources :customers, :as => 'users' do |customer|
    customer.resources :customer_payments, :as => :payments
  end

  map.resources :orders do |order|
    order.resources :order_items
  end

  map.devise_for :publishers  # first to avoid the :publishers resources to catch devise's auto-generated routes
  map.namespace :publish do |publish|
    publish.resources :publishers do |publisher|
      publisher.resources :catalogs do |catalog|
        catalog.resources :products
      end
      publisher.resources :products do |product|
        product.resources :items
        product.resources :wholesale_prices
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
    retail.resources :publishers, :only => [:index, :show]
    retail.resources :products, :only => :show
    retail.resources :items
  end

  map.root :controller => 'retail/catalogs'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

