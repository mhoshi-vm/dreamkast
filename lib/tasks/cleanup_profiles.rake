namespace :util do
  desc 'cleanup_profiles'
  task cleanup_profiles: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    Rails.logger.level = Logger::DEBUG

    abbr = ENV.fetch("EVENT_ABBR")

    ActiveRecord::Base.transaction do
      begin
        conference = Conference.find_by(abbr: abbr)
        conference.profiles.each do |profile|
          AccessLog.where(profile_id: profile.id).each do |access_log|
            access_log.destroy!
          end
          RegisteredTalk.where(profile_id: profile.id).each do |registered_talk|
            registered_talk.destroy!
          end
          Agreement.where(profile_id: profile.id).each do |agreement|
            agreement.destroy!
          end
          ChatMessage.where(profile_id: profile.id).each do |chat_message|
            chat_message.update!(profile_id: nil)
          end
          profile.destroy!
        end
      rescue => e
        puts(e)
      end
    end
  end
end
