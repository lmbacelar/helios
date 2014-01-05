Helios::Application.routes.draw do
  resources :its90_functions, :iec60751_functions, :iec60584_functions do
    resources :measurements, only: :index
    resources :prt_measurements, except: :index
  end
end
