class AddUserReferencesToCompaign < ActiveRecord::Migration[5.0]
  def change
    add_reference :compaigns, :user, foreign_key: true
  end
end
