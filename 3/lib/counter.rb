# Representing a Flajolet-Martin counter
class Counter

  B = Settings::CONFIG.b

  def initialize(registers)
    @registers = nil

    init_registers(registers)
  end

  # Adds an item (number) to the counter
  def add(item)
    parts = jenkin_parts(item)
    index = parts[0]

    @registers[index] = [@registers[index], parts[1]].max
  end

  # Returns the size of the counter
  def size
    alpha * p_square * registers_sum
  end

  private

  def registers_sum
    sum = 0

    @registers.each do |value|
      sum += 2 ** -value
    end

    sum
  end

  # Alpha constant based on p (register size ) = 2 ^ B
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

  def p_square
    @registers.size ** 2
  end

  # Returns the parts from jenkins
  def jenkin_parts(item)
    bit_string = Jenkin.hash(item).to_s(2).ljust(32, '0')

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

  # Inits the registers
  def init_registers(registers)
    @registers = registers.times.map { -Float::INFINITY }
  end

end
