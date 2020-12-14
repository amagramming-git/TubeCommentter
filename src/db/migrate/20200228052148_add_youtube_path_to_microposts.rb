class AddYoutubePathToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :video_id, :string
    add_index :microposts, :video_id
  end
end
