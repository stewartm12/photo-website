class StoreMembershipsController < ApplicationController
  include Pagy::Backend

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
    Current.user.send_invitation_email(params[:email], Current.store)
    flash.now[:notice] = 'Invitation email sent successfully!'
  end

  def destroy
    store_membership = Current.store.store_memberships.find_by(id: params[:id])
    store_membership.destroy
    flash[:success] = 'Member removed successfully!'

    @store = Current.store
    @pagy, @store_memberships = pagy(filtered_memberships(@store))
  end

  private

  def filtered_memberships(store)
    store_memberships = store.store_memberships.includes(:user).joins(:user)

    if params[:name].present?
      store_memberships = store_memberships.where(
        'users.first_name ILIKE :name OR users.last_name ILIKE :name', name: "%#{params[:name]}%"
      )
    end

    store_memberships.order(created_at: :asc)
  end
end
