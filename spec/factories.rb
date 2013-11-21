FactoryGirl.define do
  factory :measurement do
    value 0
  end

  factory :temperature_measurement do
    temperature 0
  end

  factory :prt_measurement do
    temperature 0
    iec60751_prt
  end

  factory :iec60751_prt do
    sequence(:name) { |n| "PRT#{n}" }
  end
end
