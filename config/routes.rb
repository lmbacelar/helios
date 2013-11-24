Helios::Application.routes.draw do
  resources :its90_prts, :iec60751_prts do
    resources :measurements, only: :index
    resources :prt_measurements, except: :index
  end
end
