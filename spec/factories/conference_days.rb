# == Schema Information
#
# Table name: conference_days
#
#  id            :bigint           not null, primary key
#  date          :date
#  end_time      :time
#  internal      :boolean          default(FALSE), not null
#  start_time    :time
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  conference_id :bigint
#
# Indexes
#
#  index_conference_days_on_conference_id  (conference_id)
#
FactoryBot.define do
  factory :day1, class: ConferenceDay do
    id { 1 }
    conference_id { 1 }
    date { "2020-09-08" }
    start_time { "03:00:00" }
    end_time { "11:00:00" }
    internal { false }
  end

  factory :day2, class: ConferenceDay do
    id { 2 }
    conference_id { 1 }
    date { "2020-09-09" }
    start_time { "03:00:00" }
    end_time { "11:00:00" }
    internal { false }
  end

  factory :rejekt, class: ConferenceDay do
    id { 3 }
    conference_id { 3 }
    date { "2020-09-02" }
    start_time { "19:00:00" }
    end_time { "21:00:00" }
    internal { true }
  end
  factory :cndo_day1, class: ConferenceDay do
    id { 10 }
    conference_id { 2 }
    date { "2021-03-11" }
    start_time { "03:00:00" }
    end_time { "11:00:00" }
    internal { false }
  end

  factory :cndo_day2, class: ConferenceDay do
    id { 11 }
    conference_id { 2 }
    date { "2021-03-12" }
    start_time { "03:00:00" }
    end_time { "11:00:00" }
    internal { false }
  end

  factory :cndt2021_day1, class: ConferenceDay do
    id { 12 }
    conference_id { 4 }
    date { "2021-03-11" }
    start_time { "03:00:00" }
    end_time { "11:00:00" }
    internal { false }
  end

  factory :cndt2021_day2, class: ConferenceDay do
    id { 13 }
    conference_id { 4 }
    date { "2021-03-12" }
    start_time { "03:00:00" }
    end_time { "11:00:00" }
    internal { false }
  end
end
