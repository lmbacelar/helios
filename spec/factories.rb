FactoryGirl.define do
  factory :iec60751_measurement do
    temperature 0
    iec60751_prt
  end

  factory :iec60751_prt do
    sequence(:name) { |n| "PRT#{n}" }
    description 'Some description'
  end
end
