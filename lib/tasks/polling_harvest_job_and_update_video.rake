require 'slack/incoming/webhooks'

namespace :util do
  desc 'polling harvest job and update video'
  task polling_harvest_job_and_update_video: :environment do
    include EnvHelper
    include MediaPackageHelper

    slack_webhook_url = ENV['SLACK_WEBHOOK_URL']
    slack = Slack::Incoming::Webhooks.new(slack_webhook_url)
    slack.username = 'アーカイブ動画作成チェック'
    slack.channel = ENV['SLACK_CHANNEL']

    MediaPackageHarvestJob.where(status: 'IN_PROGRESS').each do |harvest_job|
      resp = harvest_job.job
      harvest_job.update!(status: resp.status)

      url = "https://#{cloudfront_domain_name(resp.s3_destination.bucket_name)}/#{resp.s3_destination.manifest_key}"
      if resp.status == 'SUCCEEDED' && harvest_job.talk.video_id == ''
        harvest_job.talk.video.update!(video_id: url)
      end

      body = []
      body << 'アーカイブの作成が完了しました:'
      body << "Track :#{harvest_job.talk.track.name}"
      body << "スピーカー: #{harvest_job.talk.speaker_names.join("\n")}"
      body << "セッション: #{harvest_job.talk.title}"
      body << "アーカイブURL: https://event.cloudnativedays.jp/#{harvest_job.conference.abbr}/talks/#{harvest_job.talk.id}"

      slack.post(body.join("\n")) unless body.empty?
    end
  end

  def cloudfront_domain_name(bucket_name)
    case bucket_name
    when 'dreamkast-ivs-stream-archive-prd'
      'd3pun3ptcv21q4.cloudfront.net'
    when 'dreamkast-ivs-stream-archive-stg'
      'd3i2o0iduabu0p.cloudfront.net'
    else
      'd1jzp6sbtx9by.cloudfront.net'
    end
  end
end
