class AddUserReferenceToBag < ActiveRecord::Migration[5.2]
  def change
    add_reference :bags, :user, index: true
  end
end
