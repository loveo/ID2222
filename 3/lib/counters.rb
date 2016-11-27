# Wrapper for node counters
class Counters

  attr_reader :counters

  def initialize
    @counters = {}
    @mutex    = Mutex.new
  end

  # Returns the counter for a specific item (node id)
  def get_counter(item)
    @mutex.synchronize do
      @counters[item] || create_counter(item)
    end
  end

  # Checks if there where any changes made in this iteration
  def any_changes?
    @counters.empty? || all_counters.any?(&:value_changed?)
  end

  # Applies any pending changes to each counter
  def apply_changes(round)
    all_counters.each { |counter| counter.apply_changes(round) }
  end

  # Returns all the counter instances
  def all_counters
    @counters.values
  end

  private

  # Creates a counter for a specific item (id)
  def create_counter(item)
    @counters[item] = Counter.new.tap do |counter|
      counter.add(item)
    end
  end

end
