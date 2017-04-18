# Factories are used as a source to always generate a valid model or a valid
# set of attributes. This is why when setting up your factory, you should always
# ensure that the generated model or attributes are valid taking into account
# any validations you may have in your model. The factory will actually invoke
# the model to generate the record so it will invoke validations as well. So
# this factory will use the `User` model to generate user records
FactoryGirl.define do
  factory :user do
    # you can put a piece of code as the value for the field in Factory Girl
    # this will make FactoryGirl invoke the piece of code everytime you use it
    first_name       { Faker::Name.first_name }
    last_name        { Faker::Name.last_name  }
    # the sequence method in FactoryGirl will generate a unique number that
    # increments every time you invoke FactoryGirl on this model. It's a good
    # method to use to ensure that a given generated string will be unique
    sequence(:email) {|n| Faker::Internet.email.gsub('@', "#{n}@") }
    password         'supersecret'

  end
end
