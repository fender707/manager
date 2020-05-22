Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'login', to: 'access_tokens#create'
  delete 'logout', to: 'access_tokens#destroy'
  resources :directories, except: [:edit] do
    member do
      patch '/update_notes_positions', to: 'directories#update_notes_positions', as: 'update_notes_positions'
    end
    resources :notes, except: [:edit]
  end
  get '/notes', to: 'notes#all_notes', as: 'all_notes_index'
end
