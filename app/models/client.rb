class Client < ApplicationRecord
  after_create :collatoral_contact

  def collatoral_contact
    result = Twilio::REST::Client.new.studio.flows(ENV["TWILIO_STUDIO_FLOW"]).executions.create(
      to: phone,
      from: ENV["TWILIO_PHONE_NUMBER"],
    )
  end
end
