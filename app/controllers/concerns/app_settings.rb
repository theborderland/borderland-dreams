module AppSettings
  def app_setting(key)
    Rails.configuration.x.firestarter_settings[key]
  end
end
