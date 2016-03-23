class AddUserModel < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      
    end
  end

  def down
    
  end
end