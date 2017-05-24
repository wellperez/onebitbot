FactoryGirl.define do
  factory :faq_link do
    question FFaker::Lorem.phrase
    answer FFaker::Lorem.phrase
    company
  end
end
