# == Schema Information
#
# Table name: sponsor_profiles
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  sub           :string(255)
#  email         :string(255)
#  conference_id :integer          not null
#  sponsor_id    :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_sponsor_profiles_on_conference_id  (conference_id)
#  index_sponsor_profiles_on_sponsor_id     (sponsor_id)
#

FactoryBot.define do
  factory :sponsor_alice, class: SponsorProfile do
    sub { 'alice' }
    email { 'alice@example.com' }
    name { 'alice' }
    conference_id { 1 }
    sponsor_id { 1 }

    trait :on_cndt2020 do
      conference_id { 1 }
    end

    trait :on_cndo2021 do
      conference_id { 2 }
    end
  end

  factory :sponsor_bob, class: SponsorProfile do
    id { 3 }
    sub { 'bob' }
    email { 'bob@example.com' }
    name { 'bob' }
    conference_id { 1 }

    trait :on_cndt2020 do
      conference_id { 1 }
    end

    trait :on_cndo2021 do
      conference_id { 2 }
    end
  end
end
