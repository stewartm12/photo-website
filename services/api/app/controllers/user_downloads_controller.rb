class UserDownloadsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @downloads = pagy(
      Current.user.user_downloads
      .not_expired
      .includes(:collection, zip_file_attachment: :blob)
      .order(created_at: :desc)
    )
  end

  def show
    download = Current.user.user_downloads.find(params[:id])

    if download.expired? || !File.exist?(download.file_path)
      redirect_to store_user_downloads_path(Current.store,), alert: 'This download is no longer available.'
    else
      send_file download.file_path,
                filename: File.basename(download.file_path),
                type: 'application/zip',
                disposition: 'attachment'
    end
  end
end
