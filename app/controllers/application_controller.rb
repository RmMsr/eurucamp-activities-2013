class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_event

  before_filter :authenticate_user!

  def current_event
    @current_event ||= begin
      Rails.env.production? ? EVENT : Event.new(Settings.event.name, Settings.event.start_time, Settings.event.end_time)
    end
  end
end
