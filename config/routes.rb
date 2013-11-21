Helios::Application.routes.draw do
  resources :iec60751_prts do
    resources :prt_measurements
  end
end
