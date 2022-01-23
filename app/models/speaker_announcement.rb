# == Schema Information
#
# Table name: speaker_announcements
#
#  id            :bigint           not null, primary key
#  body          :text(65535)      not null
#  publish       :boolean          default(FALSE)
#  publish_time  :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  conference_id :bigint           not null
#
# Indexes
#
#  index_speaker_announcements_on_conference_id  (conference_id)
#
# Foreign Keys
#
#  fk_rails_...  (conference_id => conferences.id)
#
class SpeakerAnnouncement < ApplicationRecord
  enum receiver: { person: 0, all_speaker: 1, only_accepted: 2, only_rejected: 3 }
  JA_RECEIVER = { person: '個人', all_speaker: '全員', only_accepted: 'CFP採択者', only_rejected: 'CFP非採択者' }.freeze

  belongs_to :conference
  has_many :speaker_announcement_middles, dependent: :destroy
  has_many :speakers, through: :speaker_announcement_middles

  validates :publish_time, presence: true
  validates :body, presence: true

  scope :published, lambda {
    where(publish: true)
  }

  scope :find_by_speaker, lambda { |speaker_id|
    if Speaker.find(speaker_id).has_accepted_proposal?
      joins(:speaker_announcement_middles).where(speaker_announcement_middles: { speaker_id: speaker_id }, publish: true).accepted_announcements
    else
      joins(:speaker_announcement_middles).where(speaker_announcement_middles: { speaker_id: speaker_id }, publish: true)
    end
  }

  scope :accepted_announcements, lambda {
    where(receiver: [:only_accepted, :person, :all_speaker])
  }

  def speaker_names
    return speakers.map(&:name).join(',') if person?
    JA_RECEIVER[receiver.to_sym]
  end
end
