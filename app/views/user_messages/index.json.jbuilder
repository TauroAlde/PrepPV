json.array! @users do |user|
  json.(user, :id, :full_name, :name, :mother_last_name, :father_last_name)
  json.unread_messages_count user.messages_between_self_and(current_user).unread.count

  if user.messages_between_self_and(current_user).first
    json.last_message do
    
      json.(user.messages_between_self_and(current_user).first, :id, :message, :updated_at, :user_id, :receiver_id, :segment_id)
      json.created_at user.messages_between_self_and(current_user).first.created_at_day_format
      json.read_at user.messages_between_self_and(current_user).first.read_at_day_format
      json.evidences user.messages_between_self_and(current_user).first.evidences do |evidence|
        json.(evidence, :id, :updated_at, :message_id, :user_id)
        json.url evidence.file.url
        json.name evidence.file.file.filename
      end
    end
  else
    json.last_message nil
  end

  json.messages user.messages_between_self_and(current_user) do |message|
    json.(message, :id, :message, :updated_at, :user_id, :receiver_id, :segment_id)
    json.created_at message.created_at_day_format
    json.read_at message.read_at_day_format
    json.evidences message.evidences do |evidence|
      json.(evidence, :id, :updated_at, :message_id, :user_id)
      json.url evidence.file.url
      json.name evidence.file.file.filename
    end 
  end
end