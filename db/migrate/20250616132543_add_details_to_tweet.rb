class AddDetailsToTweet < ActiveRecord::Migration[7.2]
  def change
    add_column :tweets, :lat, :float
    add_column :tweets, :lng, :float
  end
end
