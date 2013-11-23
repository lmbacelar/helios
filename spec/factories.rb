FactoryGirl.define do
  factory :measurement do
    value 0
  end

  factory :temperature_measurement do
    temperature 0
  end

  factory :prt_measurement do
    temperature 0
    factory :iec60751_prt_measurement do
      association :meter, factory: :iec60751_prt
    end
  end

  factory :iec60751_prt do
    sequence(:name) { |n| "PRT#{n}" }
  end

  factory :its90_prt do
    sequence(:name) { |n| "PRT#{n}" }
  end
end
