Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'login', to: 'access_tokens#create'
  delete 'logout', to: 'access_tokens#destroy'
  resources :directories, except: [:edit] do
    resources :notes, only: %i[index create update destroy]
  end
  get '/notes', to: 'notes#all_notes', as: 'all_notes_index'
end
