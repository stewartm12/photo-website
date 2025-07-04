class UserDownloadsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @downloads = pagy(Current.user.user_downloads.includes(:collection).order(created_at: :desc))
  end

  def show
    download = Current.user.user_downloads.find(params[:id])

    if download.expired? || !File.exist?(download.file_path)
      redirect_to photo_downloads_path, alert: "This download is no longer available."
    else
      send_file download.file_path,
                filename: File.basename(download.file_path),
                type: "application/zip",
                disposition: "attachment"
    end
  end
end
