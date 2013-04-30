module Senses

  MAX_HEALTH = 20

  def injured?
    warrior.health < MAX_HEALTH
  end

  def under_attack?
    previous_health.to_i > warrior.health
  end

  def ready_to_fight?
    previous_health == MAX_HEALTH
  end

  def on_the_wall?
    warrior.feel(:backward).wall?
  end

  def danger?
    warrior.health < (MAX_HEALTH * 0.5)
  end

  def must_retreat?
    danger? and under_attack?
  end

  def backward?
    direction == :backward
  end

  def panorama
    warrior.look(direction).reject{|s| s.empty? and !s.stairs? }
  end

  def enemy_on_sight?
    panorama == [] ? false : panorama.first.enemy?
  end

  def wall_on_sight?
    panorama == [] ? false : panorama.first.wall?
  end

  def stairs_far_away?
    panorama == [] ? false : panorama.last.stairs?
  end

  def borderline?
    wall_on_sight? or stairs_far_away?
  end

end
