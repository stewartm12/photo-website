class RemoveFilePathFromUserDownloads < ActiveRecord::Migration[8.0]
  def change
    remove_column :user_downloads, :file_path
  end
end
