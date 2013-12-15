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
      association :transfer_function, factory: :iec60751_function
    end
  end

  factory :iec60751_function do
    sequence(:name) { |n| "FUNCTION#{n}" }
  end

  factory :its90_function do
    sequence(:name) { |n| "FUNCTION#{n}" }
  end
end
