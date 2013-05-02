class Player

  ALLOW_DIR  = %w{feel walk rescue attack shoot bind}

  autoload :Action, "action.rb"

  attr_reader :warrior, :previous_health, :action

  def play_turn(warrior)
    set_instance_variables(warrior)
    go
  end

  private

    def go
      if ALLOW_DIR.include?(action.ability.to_s)
        warrior.send("#{action.ability}!", action.dir)
      else
        warrior.send("#{action.ability}!")
      end

      @previous_health = warrior.health
    end

    def action
      @action ||= @action_klass.next(previous_health)
    end

    def set_instance_variables(warrior)
      @warrior = warrior
      @action  = nil

      @action_klass ||= Action.new(warrior)
    end
end
