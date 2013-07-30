Rails.application.routes.draw do

  mount Georgia::Engine => '/admin'
  mount Henry::Engine => '/api'
  mount Ckeditor::Engine => '/ckeditor'


  resources :pages, only: [] do
    get :preview, on: :member
  end

  resources :messages, only: [:create]

  root to: 'pages#show', slug: 'home'

  get '*path', to: 'pages#show', as: :page

end