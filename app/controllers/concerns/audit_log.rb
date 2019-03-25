module AuditLog
  include ActiveSupport::Concern

  def audit_log(type, text=nil, object_id=nil, object_name=nil, user=current_user)
    LogEntry.new { |l|
      l.type = type
      l.user_id = user.email
      l.user_name = ""          # TODO users need pretty names
      l.object_id = object_id
      l.object_name = object_name
      l.description = text
    }.save()
  end
end
