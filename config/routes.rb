ActionController::Routing::Routes.draw do |map|
  map.devise_for :customers, :as => 'users'  # first to avoid the :customers resources to catch devise's auto-generated routes
  map.resources :customers, :as => 'users' do |customer|
    customer.resources :customer_payments, :as => :payments
  end

  map.devise_for :publishers  # first to avoid the :publishers resources to catch devise's auto-generated routes
  map.publisher_root 'publisher', :controller => 'publish/publishers', :action => 'home'
  map.publish_support '/publisher/support/:action', :controller => 'publish/support'
  map.namespace :publish do |publish|
    publish.resources :publishers, :only => [:edit, :show] do |publisher|
      publisher.resources :catalogs, :has_many => :products

      publisher.resources :products, :member => { :iso => :post, :remove_iso => :get }, :has_many => :items do |product|
        product.modal '/modal/:action/:id', :controller => 'modal'
      end

      publisher.resources :product_options, :as => 'options', :only => [:create]
      publisher.resources :product_placements, :as => 'placements', :only => [:create]

      publisher.resources :genres, :only => :index
      publisher.resources :get_stocks, :only => [:index, :create, :show]
      publisher.resources :sales, :only => [:index, :show], :collection => {:ledger => :get}

      publisher.resources :financial_informations, :as => :financial, :member => { :send_deposit => :post, :make_default => :post, :validate => [ :get, :post, :put ] }, :except => [ :show, :edit, :destroy ]
      publisher.resources :payments, :as => :payments, :only => [:index, :show]

      publisher.support '/support/:action', :controller => 'support'
    end
    
    publish.resources :products_options
    publish.resources :catalogs_products
    publish.resources :products

    # leave this route auth-less for publisher sign-up marketing
    publish.root :controller => 'home'
  end
  map.connect '/introduction/:id', :controller => 'affiliate/affiliate_introductions', :action => 'use'

  # remove non-nested resources once authentication is worked out
  map.namespace :retail do |retail|
    retail.resources :catalogs, :only => [:index, :show] do |catalog|
      catalog.resources :products, :only => :show, :member => { :flag => :post }
    end
    retail.resources :genres, :only => [:index, :show] do |genre|
      genre.resources :products, :only => :show
    end
    retail.resources :publishers, :only => [:index, :show]

    retail.resources :customers, :has_many => :orders do |customer|
      customer.resource :cart do |cart|
        cart.resources :cart_items, :as => 'items'
      end
    end

    retail.root :controller => 'home'
  end

  map.devise_for :admins
  map.namespace :admin do |admin|
    admin.resources :fees, :genres
    admin.resources :orders, :only => [:index, :show]
    admin.resources :affiliates
    admin.resources :publishers, :except => [:create, :new]
    admin.resources :bulk_payments, :as => 'payments', :except => [ :edit, :delete ],
                    :member => { :generate => [ :get, :post ], :validate => [ :get, :post ], :ach => :get, :paypal => :get },
                    :has_many => :payments do |bulk_payment|
      bulk_payment.resources :payments, :only => [ :index ]
    end
    admin.resources :wholesalers, :except => [:create, :new], :has_many => :wholesaler_invoices do |wholesaler|
      wholesaler.resources :invoices, :except => [:create, :new, :delete], :as => 'invoices', :has_many => :wholesaler_payments do |invoice|
        invoice.resources :wholesaler_payments, :as => 'payments'
      end
    end
    admin.resources :packaging_options, :as => 'packaging'
    admin.resources :shipping_options, :as => 'shipping'
    admin.resources :wholesale_prices, :as => 'wholesale'

    # route needed for Devise after_sign_in, always auth-ful because it's admin's
    admin.root :controller => 'home'
  end
  
  map.devise_for :wholesalers
  map.namespace :wholesale do |wholesale|
    wholesale.resources :wholesalers, :only => [:edit, :show] do |wholesaler|
      wholesaler.resources :orders, :has_many => :order_items, :collection => { :create => :post }
      wholesaler.resources :wholesaler_invoices, :as => 'invoices', :except => [:create, :new, :delete], :has_many => :wholesaler_payments, :member => { :pay => [ :get, :post ] }
      
      wholesaler.resources :catalogs, :only => [:index, :show] do |catalog|
        catalog.resources :products, :only => :show
      end
      
      wholesaler.resources :credit_cards, :member => { :make_default => :post }, :except => [ :edit ]
    end
    
    wholesale.root :controller => 'home'
  end
  
  map.devise_for :affiliates
  map.namespace :affiliate do |affiliate|
    affiliate.resources :affiliates, :only => [ :edit, :show ] do |affiliate1|
      affiliate1.resources :affiliate_introductions, :as => 'introductions', :only => [ :new, :create, :index ], :member => { :use => :get }
      affiliate1.resources :publishers, :only => [ :index ]
      affiliate1.resources :financial_informations, :as => :financial, :member => { :send_deposit => :post, :make_default => :post, :validate => [ :get, :post, :put ] }, :except => [ :show, :edit, :destroy ]
      affiliate1.resources :payments, :as => :payments, :only => [:index, :show]
    end
    affiliate.root :controller => 'home'
  end

  map.root :controller => 'retail/home'
end

