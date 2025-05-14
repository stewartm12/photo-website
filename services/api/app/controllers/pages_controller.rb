class PagesController < ApplicationController
  allow_unauthenticated_access
  before_action :redirect_signed_in_user

  def features; end

  def faqs; end

  def developers_info; end
end
