class CreateUserDownloads < ActiveRecord::Migration[8.0]
  def change
    create_table :user_downloads do |t|
      t.references :user, null: false
      t.references :collection
      t.datetime :expires_at, null: false
      t.string :file_path, null: false
      t.timestamps
    end
  end
end
