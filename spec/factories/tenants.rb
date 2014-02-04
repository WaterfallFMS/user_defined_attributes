# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tenant do
    sequence(:uuid) {|n| "#{"%05d" % n}"}
    sequence(:name) {|n| "Tenant #{"%05d" % n}"}
  end
end
