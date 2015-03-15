class Dance < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :dance # parent dance genre

  class DanceTree
    attr_reader :children
    def initialize(parent, dance)
      @parent = parent
      @dance = dance
    end

    def assign_children(parent, all_dances)
      my_children = all_dances.select do |dance|
        dance.dance == @dance
      end
      @children = my_children.map do |dance|
        DanceTree.new(self, dance)
      end
      @children.each do |child|
        child.assign_children(self, all_dances)
      end
    end

    def ancestors
      if @parent
        [@parent] + @parent.ancestors
      else
        []
      end
    end

    def name
      ancestor_names = ancestors.map(&:name)
      full_name = @dance.try(:name) || ''
      ancestor_names.inject(full_name) do |sum, anc_name|
        sum.gsub(anc_name, '')
      end
    end

  end

  def self.tree
    all = Dance.all.to_a
    root = DanceTree.new(nil, nil)
    root.assign_children(root, all)
    root
  end

end
