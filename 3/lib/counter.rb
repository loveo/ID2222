# Representing a Flajolet-Martin counter
class Counter

  B = Settings::CONFIG.register_bits

  attr_reader :registers

  def initialize
    @registers     = nil
    @new_registers = nil
    @changed       = false
    @mutex         = Mutex.new

    init_registers
  end

  # Adds an item (number) to the counter
  def add(item)
    parts = jenkin_parts(item)
    index = parts[0]

    @registers[index] = [@registers[index], parts[1]].max
    @new_registers = @registers.dup
  end

  # Returns the size of the counter
  def size
    alpha * p_square * (1.0 / registers_sum)
  end

  # Returns the union register between two registers
  def self.union(register_a, register_b)
    register_a.each_with_index.map do |value, index|
      [value, register_b[index]].max
    end
  end

  # Returns true if the pending registers have been altered
  def value_changed?
    @changed
  end

  # Applies any pending changes
  def apply_changes
    if @changed
      @registers = @new_registers.dup
      @changed = false
    end
  end

  # Merges this counter with anohter counter
  def merge(counter)
    @mutex.synchronize do
      @new_registers = Counter.union(@new_registers, counter.registers)
      @changed = has_changed?
    end
  end

  private

  # Returns true if this counter has changed this iteration
  def has_changed?
    @changed || new_registers_changed?
  end

  # Returns true if the new registers has changed from the current
  def new_registers_changed?
    not @new_registers == @registers
  end

  # Sums the registers acoording to HyperLogLog algorithm
  def registers_sum
    sum = 0

    @registers.each do |value|
      sum += 2 ** -value
    end

    sum
  end

  # Alpha constant based on p (register size ) = 2 ^ B from the paper
  def alpha
    case B
    when 4
      0.673
    when 5
      0.697
    when 6
      0.709
    else
      0.7213/(1 + 1.079/(2 ** B))
    end
  end

  # Helper method for p ^ 2
  def p_square
    @registers.size ** 2
  end

  # Returns the parts from jenkins
  def jenkin_parts(item)
    bit_string = Jenkins.hash(item).to_s(2).ljust(32, '0')

    register_index = bit_string[-B, B].to_i(2)
    register_value = trailing_zeroes(bit_string[0 ... -B]) + 1

    [register_index, register_value]
  end

  # Returns the number of leading zeroes
  def trailing_zeroes(number)
    if last_one = number.rindex('1')
      number.length - last_one - 1
    else
      number.length
    end
  end

  # Inits the registers with negative infinity
  def init_registers
    @registers = (2 ** B).times.map { -Float::INFINITY }
    @new_registers = @registers.dup
  end

end
