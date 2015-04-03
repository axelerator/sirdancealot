# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
Dir["#{File.dirname(__FILE__)}/../test/factories/**/*.rb"].each { |f| require f }
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

rene.create_school(name: 'SalsaHH')

