require "senses.rb"

class Direction

  attr_reader :warrior, :direction, :previous_health

  def initialize warrior
    @warrior          = warrior
    @direction        = :backward
    @borderline_count = 0
  end

  def go(previous_health)
    @previous_health = previous_health
    @direction       = first_time? ? first_time! : next!

    [@direction, @borderline_count]
  end

  private

    include Senses

    def next!
      must_retreat? ? :backward : forward!
    end

    def forward!
      @borderline_count += 1 if borderline?
      :forward
    end

    def first_time!
      if borderline?
        @borderline_count += 1
        :forward
      else
        :backward
      end
    end

    def first_time?
      @borderline_count == 0
    end

end
