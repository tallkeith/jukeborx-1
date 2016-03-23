class AddFilenameToSongs < ActiveRecord::Migration
  def up
    add_column :songs, :filename, :string
  end

  def down
    remove_column :songs, :filename
  end
end
