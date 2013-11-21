Helios::Application.routes.draw do
  resources :its90_prts
  resources :iec60751_prts do
    resources :prt_measurements
  end
end
