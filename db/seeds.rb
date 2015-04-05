# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
Dir["#{File.dirname(__FILE__)}/../test/factories/**/*.rb"].each { |f| require f }

def assert(cond, msg = "FAIL")
  raise msg unless cond
end

def create_dances(children, parent)
  case children
  when String
    Dance.create(name: children.to_s, dance: parent)
  when Symbol
    Dance.create(name: children.to_s, dance: parent)
  when Array
    children.each do |child|
      create_dances(child, parent)
    end
  when Hash
    children.each do |sub_grenre, sub_children|
      new_parent = Dance.create(name: sub_grenre, dance: parent)
      create_dances(sub_children, new_parent)
    end
  end

end
DatabaseCleaner.clean_with :truncation
{
  partner: {
    standard: ['waltz', 'quickstep', 'foxtrott', 'tango', 'viennese waltz'],
    latin: {
      'latin club' => {
        salsa: {
          'cuban salsa' => nil,
          'linear salsa' => ['salsa NY style', 'salsa LA style']
       },
        bachata: nil,

      },
      'latin ballroom' => ['cha cha', 'rumba', 'jive', 'samba', 'paso doble'],
    },
    bolero: nil
  },
  nonpartner: {
    jazz: nil,
    'hip hop' => nil
  }
}.each do |top_genre, sub_grenres|
  parent = Dance.create(name: top_genre)
  create_dances(sub_grenres, parent)
end

rene = FactoryGirl.create(:user, email: 'rene@example.org', password: '1qay2wsx')
martina = FactoryGirl.create(:user, email: 'martina@example.org', password: '1qay2wsx')

salsahh = rene.create_school(name: 'SalsaHH')
assert salsahh.persisted?

friedensalle = salsahh.create_place(name: 'Großer Raum', description: 'Friedensalle 43')
assert friedensalle.persisted?

courses_src = [
  {name: 'foo', start_time: 0, duration: '60', day: 3},
  {name: 'Kinderturnen', start_time: 9, duration: '60', day: 3},
  {name: 'NY F2', start_time: 19, duration: '60', day: 1},
  {name: 'Cubana Anfänger', start_time: 19, duration: '60', day: 1},
  {name: 'NY F1', start_time: 22, duration: '60', day: 1},
  {name: 'rueda', start_time: 21, duration: '60', day: 2}
]

courses = courses_src.map do |course_src|
  course_params = {
    "name"=> course_src[:name],
    "duration"=> 60,
    "schedule_rule_weekly_interval"=>"1",
    "schedule_rule"=>"weekly",
    "schedule_rule_weekly"=>[course_src[:day]],
    "start_day" =>  (Time.zone.now.beginning_of_week + course_src[:day].days - 1.day).to_date,
    "start_time" => course_src[:start_time] * 60
  }
  course = salsahh.create_course(course_params, friedensalle )
  assert course.persisted?
  course
end

ny_f1 = Course.find_by(name: 'NY F1')

dancer_emails = %w{yve@example.org axel@example.org gregor@example.org}
dancers = dancer_emails.map do |email|
  FactoryGirl.create(:user, email: email, password: '1qay2wsx')
end

ny_f1.add_participant(dancers)
