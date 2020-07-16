class Talk < ApplicationRecord
  belongs_to :talk_category
  belongs_to :talk_difficulty
  belongs_to :conference
  belongs_to :conference_day

  has_many :talks_speakers
  has_many :registered_talks
  has_many :speakers, through: :talks_speakers
  has_many :profiles, through: :registered_talks

  TRACK_MAP = {"1" => "A", "2" => "B", "3" => "C", "4" => "D", "5" => "E", "6" => "F"}
  SLOT_MAP = ["1200","1400","1500","1600","1700","1800","1900","2000"]

  [Time.new]

  def self.import(file)
    destroy_all
    CSV.foreach(file.path, headers: true) do |row|
      talk = new
      talk.attributes = row.to_hash.slice(*updatable_attributes)
      talk.save
    end
  end

  def self.updatable_attributes
    ["id","conference_id","title","abstract","track","talk_category_id","talk_difficulty_id","date","conference_day_id","start_time","end_time","movie_url"]
  end

  def day
    return self.conference_day_id
  end

  def track_name
    return TRACK_MAP[self.track]
  end

  def slot_number
    SLOT_MAP.each_with_index do |time, index|
      if time > self.start_time.to_time.strftime("%H%M")
        return index.to_s
      end
    end
  end

  def talk_number
    return day.to_s + track_name + slot_number
  end

  def row_start
    ((self.start_time.in_time_zone('Asia/Tokyo') - Time.zone.parse("2000-01-01 12:00")) / 60 / 10).to_i + 1
  end

  def row_end
    ((self.end_time - self.start_time).to_i / 60 / 10) + row_start
  end

  def self.find_by_params(day, slot_number_param, track)
    date = ConferenceDay.find(day.to_i).date

    after = Time.zone.parse(SLOT_MAP[slot_number_param.to_i - 1].dup.insert(2, ":")).utc.strftime("%T")
    before = (Time.zone.parse(SLOT_MAP[slot_number_param.to_i].dup.insert(2, ":")) - 60).utc.strftime("%T")

    where(date: date, track: track)
      .where("TIME(start_time) BETWEEN '#{after}' AND '#{before}'")
  end
end
