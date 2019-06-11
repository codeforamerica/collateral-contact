class Client < ApplicationRecord
  require 'open-uri'

  has_one_attached :recording

  after_create :collatoral_contact

  def collatoral_contact
    result = Twilio::REST::Client.new.studio.flows(ENV["TWILIO_STUDIO_FLOW"]).executions.create(
      to: phone,
      from: ENV["TWILIO_PHONE_NUMBER"],
    )
  end

  def update_from_twilio
    twilio = Twilio::REST::Client.new
    recordings = twilio.recordings
    most_recent_recording_sid = recordings.list.sort_by { |r| r.date_created }.last.sid
    recording = "https://api.twilio.com/2010-04-01/Accounts/"+ENV["TWILIO_ACCOUNT_SID"]+"/Recordings/"+most_recent_recording_sid+".mp3"
    self.recording.attach(
        io: open(recording,
                 http_basic_authentication: [ENV["TWILIO_ACCOUNT_SID"], ENV['TWILIO_AUTH_TOKEN']]),
        filename: 'recording.mp3',
        content_type: 'audio/mpeg')

    most_recent_execution_sid = twilio.studio.flows(ENV['TWILIO_STUDIO_FLOW']).executions.list.sort_by{|e| e.date_created}.last.sid
    execution_context = twilio.studio.flows(ENV['TWILIO_STUDIO_FLOW']).executions(most_recent_execution_sid).execution_context.fetch
    transcription = execution_context.context["flow"]["variables"]["transcription"]

    self.update transcription: transcription
  end
end
