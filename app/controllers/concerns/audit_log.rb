module AuditLog
  include ActiveSupport::Concern

  def audit_log(entry_type, description=nil, object_id=nil, object_name=nil, user=current_user)
    LogEntry.new { |l|
      l.entry_type = entry_type
      l.user_id = user.id
      l.user_email = user.email
      l.user_name = ""          # TODO users need pretty names
      l.object_id = object_id
      l.object_name = object_name
      l.description = description
    }.save()
  end
end
