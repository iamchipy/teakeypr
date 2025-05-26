# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # used to support Ahoy Counter
  before_action :set_unique_visitors_count

  private

  # used to support Ahoy Counter
  def set_unique_visitors_count
    # replace with caching version in future
    # @unique_visitors_count = Rails.cache.fetch("unique_visitors_count", expires_in: 10.minutes) do
    #   Ahoy::Visit.select(:visitor_token).distinct.count
    # end
    @unique_visitors_count = Ahoy::Visit.select(:visitor_token).distinct.count
  end
end
