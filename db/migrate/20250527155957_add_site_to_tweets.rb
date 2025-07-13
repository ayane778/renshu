class AddSiteToTweets < ActiveRecord::Migration[7.2]
  def change
    add_column :tweets, :site, :string
  end
end
