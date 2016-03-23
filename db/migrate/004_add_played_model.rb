class AddPlayedModel < ActiveRecord::Migration
  def up
    create_table :played do |t|
      t.string :song_played
      t.string :played_by
      t.datetime :time
      
    end
  end

  def down
    
  end
end