class Player

  ALLOW_DIR  = %w{feel walk rescue attack shoot}

  autoload :Direction, "direction.rb"
  autoload :Action,    "action.rb"

  attr_reader :warrior, :previous_health

  def play_turn(warrior)
    set_instance_variables(warrior)
    go
  end

  private

    def go
      if ALLOW_DIR.include?(ability.to_s)
        puts "================================ #{ability} - #{dir}"
        warrior.send("#{ability}!", dir.first)
      else
        puts "================================ #{ability}"
        warrior.send("#{ability}!")
      end

      @previous_health = warrior.health
    end

    def dir
      @dir ||= @dir_klass.go(previous_health)
    end

    def ability
      @ability ||= @ability_klass.go(dir, previous_health)
    end

    def set_instance_variables(warrior)
      @warrior = warrior
      @dir     = nil
      @ability = nil

      @dir_klass     ||= Direction.new(warrior)
      @ability_klass ||= Action.new(warrior)
    end

end
