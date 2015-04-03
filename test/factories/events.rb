FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  sequence :dance_name do |i|
    "Salsa on#{i}"
  end

  factory :dance do
    name { generate(:dance_name) }
  end

  sequence :facility_name do |i|
    "#{Faker::Name.first_name}'s dance school"
  end

  factory :place do
    factory :facility, class: Facility do
      name { generate(:facility_name) }
    end
  end


  sequence :course_name do |i|
    "Course #{i}"
  end

  sequence :party_name do |i|
    "Party #{i}"
  end

  factory :event_group do
    starts_at Time.now + 1.week
    factory :course, class: Course do
      name { generate(:course_name) }
      after(:create) do |course, evaluator|
        course.dances << create(:dance)
      end
    end

    factory :party_row, class: PartyRow do
      name { generate(:party_name) }
      after(:create) do |party_row, evaluator|
        party_row.dances << create(:dance)
      end
    end
  end


  factory :event do
    starts_at Time.now + 2.days
    ends_at Time.now + 2.days + 2.hours
    association :place, factory: :facility

    factory :lesson, class: Lesson do
      association :event_group, factory: :course

      after(:create) do |lesson|
        lesson.event_group.dances.each do |dance|
          lesson.dances << dance
        end
      end
    end

    factory :party, class: Party do
      association :event_group, factory: :party_row

      after(:create) do |party|
        party.event_group.dances.each do |dance|
          party.dances << dance
        end
      end
    end
  end

  sequence :school_name do |i|
    "#{Faker::Name.first_name}'s dance company"
  end

  factory :institution do
    factory :school, class: School do
      name { generate(:school_name) }
    end
  end

end
