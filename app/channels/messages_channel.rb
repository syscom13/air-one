class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation_#{params[:id]}"
    # params[:id] comes from id: $('#user_id').val() in App.messages = App.cable.subscriptions.create {channel: 'MessagesChannel', id: $('#conversation_id').val() },
  end
end
