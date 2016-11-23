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
    @counters.empty? || @counters.values.any?(&:value_changed?)
  end

  # Applies any pending changes to each counter
  def apply_changes
    @counters.values.each(&:apply_changes)
  end

  # TODO REMOVE HELPER METHOD
  def get_changed_counters
    @counters.values.reject { |counter| not counter.value_changed? }
  end

  private

  # Creates a counter for a specific item (id)
  def create_counter(item)
    @counters[item] = Counter.new.tap do |counter|
      counter.add(item)
    end
  end

end
