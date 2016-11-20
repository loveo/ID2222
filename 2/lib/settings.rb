# Holder class for settings
class Settings

  CONFIG = OpenStruct.new(
    support_threshold:      0.01, # fraction of baskets that should support an item set
    confidence_threshold:   0.5,  # confidence threshold for association rules
    pool_size:              8     # number of worker threads   
    )

  # Sets support threshold and confidence threshold if present
  def self.read_arguments
    support    = ARGV[0].to_f
    confidence = ARGV[1].to_f

    CONFIG.support_threshold = support if support > 0
    CONFIG.confidence_threshold = confidence if confidence > 0
  end

end
