class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_#{params[:id]}"
    # params[:id] comes from id: $('#user_id').val() in App.notifications = App.cable.subscriptions.create {channel: "NotificationsChannel", id: $('#user_id').val() },
  end
end
