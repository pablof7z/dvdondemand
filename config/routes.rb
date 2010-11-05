ActionController::Routing::Routes.draw do |map|

  map.resources :fees

  map.resources :shipping_options

  map.resources :packaging_options

  map.devise_for :customers, :as => 'users'  # first to avoid the :customers resources to catch devise's auto-generated routes
  map.resources :customers, :as => 'users' do |customer|
    customer.resources :customer_payments, :as => :payments
  end

  map.devise_for :publishers  # first to avoid the :publishers resources to catch devise's auto-generated routes
  map.publisher_root 'publisher', :controller => 'publish/publishers', :action => 'home'
  map.namespace :publish do |publish|
    publish.resources :publishers, :only => [:edit, :show] do |publisher|
      publisher.resources :catalogs, :has_many => :products
      publisher.resources :products, :has_many => :items

      publisher.resources :genres, :only => :index
      publisher.resources :sales,  :only => [:index, :show]

      publisher.resources :publisher_payments, :as => :payments, :only => [:index, :show]
    end

    publish.resources :products do |product|
      product.resources :isos, :only => [:create, :destroy, :show]
    end

    # leave this route auth-less for publisher sign-up marketing
    publish.root :controller => 'home'
  end

  # remove non-nested resources once authentication is worked out
  map.namespace :retail do |retail|
    retail.resources :catalogs, :only => [:index, :show] do |catalog|
      catalog.resources :products, :only => :show
    end
    retail.resources :publishers, :only => [:index, :show]

    retail.resources :customers, :has_many => :orders

    retail.cart     'cart',     :controller => 'cart', :action => 'index'
    retail.cart_add 'cart_add', :controller => 'cart', :action => 'add_item'
    retail.cart_del 'cart_del/:product_id', :controller => 'cart', :action => 'del_item'

    retail.root :controller => 'catalogs'
  end

  map.devise_for :admins
  map.namespace :admin do |admin|
    admin.resources :genres
    admin.resources :publishers, :except => [:create, :new]
    admin.resources :packaging_options, :as => 'packaging'
    admin.resources :wholesale_prices, :as => 'wholesale'

    # route needed for Devise after_sign_in, always auth-ful because it's admin's
    admin.root :controller => 'home'
  end

  map.root :controller => 'retail/catalogs'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

