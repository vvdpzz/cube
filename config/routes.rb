Cube::Application.routes.draw do
 
   match '/mails/inbox' => 'mails#inbox', :via => 'get' #inbox
   match '/mails/reply/to/:id' => 'mails#renew', :via => 'get' #to reply a new mail
   match '/mails/:batch_id' => 'mails#view', :via => 'get' #to view a single batch mail  
   match '/mailsent' => 'mails#create', :via => 'post' #mail sent
   match '/mailreplied' => 'mails#reply', :via => 'post' #mai replied
 
 
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
      
      post "comments" => "questions#create_comment"
    end
    
    resources :answers, :only => [] do
      member do
        put "accept"
      end
    end
  end
  
  resources :answers, :only => [:create] do
    member do
      post "comments" => "questions#create_comment"
    end
  end
  
  root :to => 'questions#paid'
  
  devise_for :users
end
