Rails.application.routes.draw do
  
  root "events#index"

  get "events/filter/:show_only", to: "events#index", as: :filtered_events

  resources :categories
  
  # Since registrations only make sense in the context of events
  # we should nest the registrations routes under the event routes
  # This sets up a hierarchy: the event id must be present in the routes
  # for registrations path
  # like events/:id/registrations/new
  # the registration related routes are embeded under events/:id
  resources :events do
    resources :registrations
    resources :likes
  end

  # since there will be only one session per user, we use the singular form of resource and the resource name (:session)
  # this way the routes won't contain an :id param for destroying a session
  resource :session, only: [:new, :create, :destroy]

  resources :users
  get "signup", to: "users#new"
    
  
  # get "events", to: "events#index"
  # get "events/new", to: "events#new"
  # get "events/:id", to: "events#show", as: "event"
  # get "events/:id/edit", to: "events#edit", as: "edit_event"
  # patch "events/:id", to: "events#update"
end
