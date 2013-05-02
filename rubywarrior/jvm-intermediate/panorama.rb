class Panorama

  DIRECTIONS = [:forward, :left, :right, :backward]

  autoload :Subject, "subject.rb"

  attr_reader :warrior

  def initialize warrior
    @warrior = warrior
    @history = []
  end

  def look!
    @stronger_enemy = nil

    @history << DIRECTIONS.collect{|d|
      Subject.new(d, warrior.feel(d))
    }
  end

  def current
    @history.last
  end

  def enemies
    warrior.listen.select(&:enemy?)
  end

  def enemies_around
    current.select{|subject| subject.enemy? }
  end

  def active_enemies
    enemies_around.reject(&:bind?)
  end

  def bind_enemies
    enemies_around.select(&:bind?)
  end

  def captives_around
    current.select{|subject| subject.captive? }
  end

  def captives
    warrior.listen.select(&:captive?).sort_by{|c| c.ticking? ? 0 : 1 }
  end

  def captives?
    captives.size > 0
  end

  def enemy_on_sight?
    active_enemies.size > 0
  end

  def stronger_enemy
    active_enemies.max_by{|s| s.hp }
  end

  def enemy_to_bind
    active_enemies.reject{|e| e.dir == best_dir_to_rescue }.max_by{|s| s.hp }
  end

  def empty?
    warrior.listen.size == 0
  end

  def subjects?
    current.select(&:subject?).size > 0
  end

  def ambush?
    active_enemies.size > 1
  end

  def need_a_bomb?
    return false if !ticking? and captives?
    warrior.look(stronger_enemy.dir).first(2).select(&:enemy?).size == 2
  end

  def enemy_ahead?(dir)
    warrior.look(dir).first(2).last.enemy?
  end

  def ticking?
    captives.select(&:ticking?).size > 0
  end

  def best_dir_to_rescue
    warrior.direction_of(captives.first)
  end

  def obstacle_to_rescue?
    !warrior.feel(best_dir_to_rescue).empty?
  end

  def next_direction
    if captives?
      avoid_stairs warrior.direction_of(captives.first)
    elsif enemies.size > 0
      avoid_stairs warrior.direction_of(enemies.first)
    else
      warrior.direction_of_stairs
    end
  end

  def empty_space
    current.detect(&:empty?)
  end

  def avoid_stairs dir
    return dir unless warrior.feel.stairs?
    empty_space.dir
  end

end
