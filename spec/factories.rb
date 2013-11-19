FactoryGirl.define do
  factory :iec60751_measurement do
    temperature 0
  end

  factory :iec60751_prt do
    sequence(:code) { |n| "PRT#{n}" }
    description 'Some description'
  end
end
