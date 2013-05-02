class Subject

  attr_reader :dir, :subject, :hp

  DAMAGES = { forward: 5, backward: 3, left: 5, right: 5, detonate: 8 }

  def initialize dir, subject
    @dir     = dir
    @subject = subject
    @hp      = load_hp
    @bind    = false
  end

  def method_missing(meth, *args, &b)
    subject.method(meth).call(*args, &b)
  end

  def enemy?
    alive? and (bind? or subject.enemy?)
  end

  def empty?
    !subject.stairs? and subject.empty?
  end

  def captive?
    !bind? and subject.captive?
  end

  def attack!
    @hp -= DAMAGES[dir].to_i
  end

  def detonate!
    @hp -= DAMAGES[:detonate].to_i
  end

  def subject?
    enemy? or captive?
  end

  def bind!
    @bind = true
  end

  def unbind!
    @bind = false
  end

  def bind?
    @bind == true
  end

  def resists_coup?
    (@hp - DAMAGES[dir].to_i) > 0
  end

  def resists_pump?
    (@hp - DAMAGES[:detonate].to_i) > 0
  end

  private

    def alive?
      @hp > 0
    end

    def load_hp
      case subject.to_s
      when "Sludge"       then 12
      when "Thick Sludge" then 24
      else 0
      end
    end

end
