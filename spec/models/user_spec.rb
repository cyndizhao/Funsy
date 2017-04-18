require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires an email' do
      #GIVEN: a new user object without an email
      u = User.new
      # WHEN: we invoke validations
      u.valid?
      #Then: we get an error on the email field
      expect(u.errors.messages).to have_key(:email)
    end

    it 'requires a unique email' do
      #GIVEN: a new user object with a email already exsting in database
      # Given:
      s = FactoryGirl.create(:user)
      u = User.new email: s.email


      # User.create first_name:'Cyndi',
      #             last_name: 'Zhao',
      #             email: 'cyndi@example.com',
      #             password: 'supersecret'
      # u = User.new email: 'cyndi@example.com'
      #WHEN: We invoke validation
      u.valid?
      #THEN: We have an error on the 'email' field
      expect(u.errors.messages).to have_key(:email)
    end
  end
  # pending "add some examples to (or delete) #{__FILE__}"
end
