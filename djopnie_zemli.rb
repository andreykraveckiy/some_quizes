string = "rrrrrr?llllddrr?rrdruurur?rur?dddldrdruuuuuur?dddr?dddrrurdruuuurrurruuurrr?drrr?ruuurdr?dr?r?ddlllllddddr?drrrr?r?dldrrurrruruurrdrrdrdddrrrrrdddddd?d?lddrddrrddddddd?ldd?lllldd?d?drrrdllddrrrrdllddldrrrrr"

class Map
  attr_reader :map, :way, :vert, :hor

  def initialize(way, size_v, size_h)
    @way = way
    @map = Array.new(size_v) { Array.new(size_h, 0) }
  end

  def complete?
    draw_way
    (vert == (map.length - 1)) && (hor == (map[vert].length - 1))
  end

  def show
    draw_way
    map.each { |line| p line }
    (vert == (map.length - 1)) && (hor == (map[vert].length - 1))
  end

  private

  def draw_way
    @vert = 0
    @hor = 0
    way.downcase.each_char do |dirrection|
      @vert, @hor = next_position(dirrection)

      if can_move?(dirrection)
        map[vert][hor] = 1
      else
        map[vert][hor] = dirrection.ord
        return
      end
    end
  end

  def can_move?(dir)
    return false if vert == map.length || hor == map[vert].length
    return false if vert < 0 || hor < 0
    return false if map[vert][hor] == 1
    true
  end

  def next_position(dir)
    case dir
    when "r"
      [vert, hor + 1]
    when "l"
      [vert, hor - 1]
    when "d"
      [vert + 1, hor]
    when "u"
      [vert - 1, hor]
    else
      [vert, hor]
    end
  end
end

class Solver
  attr_reader :way, :size_vertical, :size_horizontal

  def initialize(way, size_vertical, size_horizontal)
    @way = way
    @size_vertical, @size_horizontal = size_vertical, size_horizontal
  end

  def solve
    first_attempt
    while 1
      if pass?
        p @attempt
        return @change if try
      end
      next_step
    end
  end

  def variations
    @_var = begin
              unknown = way.each_char.each_cons(3).select {|a,b,c| b == "?"}
              variations = unknown.inject([]) do |prod, arr|
                             steps = %w[U D R L]
                             steps.delete("U") if arr.include?("d")
                             steps.delete("D") if arr.include?("u")
                             steps.delete("R") if arr.include?("l")
                             steps.delete("L") if arr.include?("r")
                             prod << steps
                           end
              variations.first.delete("U")
              variations
            end
  end

  def first_attempt
    @attempt ||= variations.map(&:first)
  end

  def pass?
    ((@attempt.count("D") - @attempt.count("U")) == 12) && ((@attempt.count("L") - @attempt.count("R")) == 4)
  end

  def next_step
    count = @attempt.count - 1
    if @attempt.last != variations[count].last
      @attempt << variations[count][variations[count].index(@attempt.pop) + 1]
    else
      long_pop
      @attempt << variations[@attempt.count - 1][variations[@attempt.count - 1].index(@attempt.pop) + 1]
      long_push
    end
  end

  def long_pop
    while 1
      break if @attempt.last != variations[@attempt.count - 1].last && (@attempt.count("R") < 2)
      @attempt.pop
    end
  end

  def long_push
    while @attempt.count != 20
      @attempt.push(variations[@attempt.count].first)
    end
  end

  def try
    @change = way.split("?").map.with_index{ |a, i| a + @attempt[i].to_s }.join
    map = Map.new(@change, size_vertical, size_horizontal)
    map.show
  end
end

Solver.new(string, 50, 50).solve


