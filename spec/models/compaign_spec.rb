require 'rails_helper'

RSpec.describe Compaign, type: :model do
  #whenever you want to start a new group of test examples, you can use either 'describe' or 'context'. they are functionally the same but depending on the context, one maybe better than the other
  describe 'Validations' do
    #whenever you want to define a test example you use 'it' or 'specify'. They are functionally the same
    #Make sure to give a good description about your test
    it 'requires a title' do
      #GIVEN: we have a new compaign object
      c = Compaign.new
      #WHEN: we invoke validations
      c.valid?
      #THEN
      #when we want to test outcome in RSpec we always start with 'expect'
      #RSpec can use 'matching' which is more sophisticted than simple equality check
      #expect(c).to be_invalid
      expect(c.errors).to have_key(:title)
    end

    it 'requires a unique title' do
      #GIVEN: we have a new compaign object and we have an exsiting compaign record in the database(with same title as the new one)
      Compaign.create({title: 'abc', body:'xyz', goal: 10, end_date: 60.days.from_now})
      c = Compaign.new({title: 'abc'})
      #WHEN: we invoke validations
      c.valid?
      #THEN: expect c to have errors on the title field
      expect(c.errors).to have_key(:title)

    end

  end
end
