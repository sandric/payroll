Rails.application.routes.draw do
  root "payrolls#index"

  resources :payrolls
end
