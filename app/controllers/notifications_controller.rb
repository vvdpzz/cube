class NotificationsController < ApplicationController
  def read
    current_user.notifications.find(params[:notification_id]).update_attributes(:read => true)
    render :nothing => true
    # TODO what kind of JSON data should I return for front?
  end
end
