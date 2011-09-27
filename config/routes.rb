Cube::Application.routes.draw do
  resources :questions, :except => [:index, :new, :edit, :destroy] do
    collection do
      get "paid"
      get "free"
      get "nearby"
      get "watching"
    end
    
    member do
      put "star"
      delete "star" => "questions#unstar"
      get "star" => "questions#is_star"
      
      put "follow"
      delete "follow" => "questions#unfollow"
      get "follow" => "questions#is_follow"
      
      post "comments" => "comments#create"
    end
    
    resources :answers, :only => [] do
      member do
        put "accept"
      end
    end
  end
  
  resources :answers, :only => [:create]
  
  root :to => 'questions#paid'
  
  devise_for :users
end
