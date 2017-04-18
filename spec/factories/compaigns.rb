FactoryGirl.define do
  factory :compaign do
    association :user, factory: :user
    # using the `assocation` method will make the factory create a user before
    # creating the campaign and then associating the created campaign with the
    # user just created

    title       { Faker::Commerce.product_name }
    body        { Faker::Hipster.paragraph }
    goal        { 10 + rand(100000) }
    end_date    { 60.days.from_now }
  end
end
