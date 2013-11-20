Helios::Application.routes.draw do
  resources :iec60751_prts do
    resources :iec60751_measurements
  end
end
