# app/controllers/users_controller.rb


class UsersController < ApplicationController
  before_action :authenticate_user!  # optional, if you want to restrict access

  def search
    term = params[:q].to_s.strip

    # better parsing since I've not locked in var type in JS
    exclude_ids_raw = params[:exclude_ids]
    exclude_ids = exclude_ids_raw.is_a?(Array) ? exclude_ids_raw.map(&:to_i) : exclude_ids_raw.to_s.split(",").map(&:to_i)

    # just for debug and tracking
    Rails.logger.debug "User Search: '#{term}' Exclude(#{exclude_ids.inspect})"

    time_entries = User.where.not(id: exclude_ids)
    time_entries = time_entries.where("name ILIKE ?", "%#{term}%") if term.present?

    render json: time_entries.limit(20).map { |t| { id: t.id, text: "#{t.name}" } }
  end
end
