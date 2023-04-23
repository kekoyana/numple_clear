class Board
  attr_accessor :squares

  def strings=(strings)
    @squares = strings.map { _1.split(//) }.flatten.map { Square.init(_1) }
  end

  def yoko
    @squares.each_slice(9).to_a
  end

  def tate
    yoko.transpose
  end

  def blk
    3.times.each_with_object([]) do |j, obj|
      3.times.each do |i|
      obj << @squares[(j*27+i*3+0)..(j*27+i*3+2)] +
        @squares[(j*27+i*3+9)..(j*27+i*3+11)] +
        @squares[(j*27+i*3+18)..(j*27+i*3+20)]
      end
    end
  end

  def check
    loop do
      reset_changed
      check_impossible
      next if changed?
      check_from_num
      next if changed?
      check_possibles
      break unless changed?
    end
  end

  def to_s
    yoko.map do |group|
      group.map do |square|
        square.number || '_'
      end.join
    end.join("\n")
  end

  private

  def check_impossible
    [yoko, tate, blk].each do |items|
      items.each { check_impossible_group(_1) }
    end
  end

  def check_from_num
    [yoko, tate, blk].each do |items|
      items.each { check_from_num_group(_1) }
    end
  end

  def check_possibles
    [yoko, tate, blk].each do |items|
      items.each { check_possibles_group(_1) }
    end
  end

  def check_impossible_group(group)
    numbers = group.map(&:number).compact
    group.each { _1.add_wrong(numbers) }
  end

  def check_from_num_group(group)
    # 他のwrongすべてに入っており、1個しか候補がなければ確定
    ([*1..9] - group.map(&:number)).each do |i|
      tmp = group.reject { |square| square.wrongs === i }
      next if tmp.size != 1
      tmp.first.set_number(i)
    end
  end

  def check_possibles_group(group)
    # possiblesの中身が同じものが個数個あったら他のものには入らない
    tmps = group.map(&:possibles).group_by(&:itself).transform_values(&:size)
    tmps.each do |set, cnt|
      if set.size == cnt
        group.each do |square|
          next if square.number
          next if set == square.possibles
          square.add_wrong(set)
        end
      end
    end
  end

  def changed?
    @squares.any?(&:changed)
  end

  def reset_changed
    @squares.each(&:reset_changed)
  end
end
