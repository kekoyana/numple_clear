class Square
  attr_reader :number
  attr_accessor :wrongs
  attr_accessor :changed

  def self.init(num = nil)
    obj = new
    obj.init(num.to_i)
    obj
  end

  def init(num)
    if !num.zero?
      set_number(num)
    else
      @wrongs = Set.new
    end
    reset_changed
  end

  def add_wrong(num)
    return if @number
    num_set = Set[*Array(num)]
    return if num_set.subset?(@wrongs)

    @wrongs += num_set
    set_number(possibles.first) if possibles.count == 1
    @changed = true
  end

  def set_number(num)
    @number = num.to_i
    @wrongs = Set.new([*1..9] - [num])
    @changed = true
  end

  def possibles
    Set[*1..9] - @wrongs
  end

  def reset_changed
    @changed = false
  end
end
