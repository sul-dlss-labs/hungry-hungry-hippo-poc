# frozen_string_literal: true

SdrClient::RedesignedClient.configure(
  url: Settings.sdr_api.url,
  email: Settings.sdr_api.email,
  password: Rails.application.credentials.dig(:sdr_api, :password)
)

# Configure dor-services-client to use the dor-services URL
Dor::Services::Client.configure(url: Settings.dor_services.url,
                                token: Rails.application.credentials.dig(:dor_services, :token))
