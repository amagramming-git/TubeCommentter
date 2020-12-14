class CreateYoutubes < ActiveRecord::Migration[5.2]
  def change
    create_table :youtubes do |t|
      t.string :video_id
      t.string :thumbnail
      t.string :channel_id
      t.string :channel_icon
      t.string :channel_title
      t.string :description
      t.string :title
      t.datetime :published_at
      t.string :live_broadcast_content
      t.timestamps
    end
  end
end
