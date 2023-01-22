class UbibotAuth < ApplicationRecord
  encrypts :token
  @ubibot_auth_url = "#{Rails.application.config.ubibot_auth_url}?account_key=#{Rails.application.credentials.ubibot_account_key}"
  def self.get_token
    correlation_id = SecureRandom.uuid
    log_message = { correlation_id: correlation_id, message: "Requested UbiBot auth_token" }
    Rails.logger.debug log_message.to_json
    last_auth = UbibotAuth.where("expired_at > :current_timestamp",{current_timestamp: DateTime.now}).order(expired_at: :desc).first
    if last_auth
      log_message["message"] = "Return existing UbiBot auth_token"
      Rails.logger.debug log_message.to_json
      return last_auth.token
    else
      log_message["message"] = "Requesting new UbiBot auth_token"
      Rails.logger.debug log_message.to_json
      response = Faraday.get(@ubibot_auth_url)
      if response.status == 200
        auth = UbibotAuth.create(
          expired_at:  JSON.parse(response.body)["expire_time"],
          server_time: JSON.parse(response.body)["server_time"],
          token:       JSON.parse(response.body)["token_id"]
        )
        return auth.token
      end
    end
  end
end
