class StoreMembershipsController < ApplicationController
  skip_before_action :set_current_store_from_slug, only: %i[show]

  def show
    user = User.find_by_token_for(:invitation_confirmation, params[:token])
    store = Store.find_by(slug: params[:store_slug])

    if user.nil? || store.nil?
      redirect_to stores_path, alert: 'Invalid or expired confirmation link' and return
    end
  
    membership = StoreMembership.new(user: Current.user, store: store)
  
    if membership.save
      redirect_to stores_path, notice: "You have successfully joined #{store.name}!"
    else
      redirect_to stores_path, alert: membership.errors.full_messages.to_sentence
    end
  end

  def new; end

  def create
    Current.user.send_invitation_email(params[:email_address], Current.store)
    flash.now[:notice] = 'Invitation email sent successfully!'
  end
end
