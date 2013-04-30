require "senses.rb"

class Action

  SUBJECTS = %w{enemy captive}

  attr_reader :warrior, :direction, :previous_health

  def initialize warrior
    @warrior = warrior
  end

  def go(direction, previous_health)
    @direction        = direction.first
    @borderline_count = direction.last
    @previous_health  = previous_health

    enemy_on_sight? ? :shoot : feel!
  end

  private

    include Senses

    def feel!
      if wall_on_sight? and @borderline_count == 2
        :pivot
      else
        warrior.feel(direction).empty? ? forward! : action!
      end
    end

    def forward!
      under_attack? ? :walk : walk!
    end

    def walk!
      injured? ? rest! : :walk
    end

    def rest!
      enemy_on_sight? ? :rest : :walk
    end

    def action!
      case subject
      when :enemy   then attack!
      when :captive then :rescue
      else :walk
      end
    end

    def attack!
      backward? ? :pivot : :attack
    end

    def subject
      SUBJECTS.collect{ |subject|
        warrior.feel(direction).send("#{subject}?") ? subject.to_sym : nil
      }.compact.first
    end

end
