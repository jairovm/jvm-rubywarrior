class Action

  MAX_HEALTH = 20

  autoload :Panorama, "panorama.rb"

  attr_reader :warrior, :previous_health, :panorama
  attr_reader :ability, :dir

  def initialize warrior
    @warrior  = warrior
    @panorama = Panorama.new(warrior)
    @moved    = true
  end

  def next(previous_health)
    @previous_health = previous_health
    refresh_panorama if @moved

    if panorama.ticking?
      hurry!
    else
      panorama.subjects? ? feel!  : forward!
    end

    self
  end

  private

    def hurry!
      if panorama.obstacle_to_rescue?
        feel!
      else
        walk!(panorama.best_dir_to_rescue)
      end
    end

    def feel!
      panorama.enemy_on_sight? ? attack! : rescue!
    end

    def attack!
      if    panorama.ambush?      then bind!
      elsif panorama.need_a_bomb? then detonate!
      else  normal_attack!
      end
    end

    def detonate!
      enemy = panorama.stronger_enemy

      if danger? and enemy.resists_pump?
        bind!(enemy)
      else
        set(:detonate, enemy.dir)
        enemy.detonate!
      end
    end

    def normal_attack!
      enemy = panorama.stronger_enemy

      if danger? and enemy.resists_coup?
        bind!(enemy)
      else
        set(:attack, enemy.dir)
        enemy.attack!
      end
    end

    def bind!(enemy = panorama.enemy_to_bind)
      set(:bind, enemy.dir)
      enemy.bind!
    end

    def rescue!
      captive = panorama.captives_around.first
      captive.nil? ? unbind! : set(:rescue, captive.dir)
    end

    def unbind!
      scratched? ? rest! : attack_unbind!
    end

    def attack_unbind!
      enemy = panorama.bind_enemies.first
      set(:attack, enemy.dir)
      enemy.unbind!
    end

    def forward!
      danger? ? rest! : walk!
    end

    def rest!
      panorama.empty? ? walk! : set(:rest, nil)
    end

    def walk!(dir = panorama.next_direction)
      (scratched? and panorama.enemy_ahead?(dir)) ? set(:rest, nil) : set(:walk, dir)
    end

    def set(ability, dir)
      @moved   = true if ability == :walk
      @ability = ability
      @dir     = dir
    end

    def refresh_panorama
      @moved = false
      panorama.look!
    end


    # Senses
    # ==========================================================================

    def injured?
      warrior.health < MAX_HEALTH
    end

    def under_attack?
      previous_health.to_i > warrior.health
    end

    def danger?
      warrior.health < (MAX_HEALTH * 0.4)
    end

    def damaged?
      warrior.health < (MAX_HEALTH * 0.6)
    end

    def scratched?
      warrior.health < (MAX_HEALTH * 0.8)
    end

end
