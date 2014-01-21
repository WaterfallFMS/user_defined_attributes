# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lead do
    name             'Test lead'
    sequence(:email) {|n| "lead#{"%05d" % n}@example.com"}
  end
end
