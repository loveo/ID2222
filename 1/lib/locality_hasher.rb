# Calculates which files are candidates and should be compared
class LocalityHasher

  attr_reader :files

  def initialize(files)
    @files = files
    @table = HashTable.new(Settings::CONFIG.table_size)
    @band_settings = nil

    calculate_band_settings
    place_files_in_buckets
  end

  # Gets the candidates of a file exluding the given file
  def candidates_of(file)
    @table.candidates_of(file).delete(file)
  end

  private 

  # Calculates which band settings to use 
  def calculate_band_settings
    min_hashes = Settings::CONFIG.min_hashes
    settings = []

    (1 .. min_hashes).each do |bands|
      if min_hashes % bands == 0
        settings << LocalityHasher.create_setting(bands, min_hashes)
      end
    end

    choose_best_setting(settings)
  end

  # Creates a row-band setting
  def self.create_setting(bands, min_hashes)
    rows = min_hashes / bands
    probability = (1/bands.to_f) ** (1/rows.to_f)

    BandSetting.new(bands, rows, probability)
  end

  # Choses the best setting for this project based on similarity threshold
  def choose_best_setting(settings)
    threshold = Settings::CONFIG.similarity
    best_setting = BandSetting.new(-1, -1, -1)

    settings.each do |setting|
      best_setting = LocalityHasher.update_best_setting(
        best_setting,
        setting,
        threshold
        )
    end

    @band_settings = best_setting
  end

  # Returns the most suitabale band setting
  def self.update_best_setting(best_setting, possible_setting, threshold)
    probability = possible_setting.probability

    if probability < threshold && probability > best_setting.probability
      possible_setting
    else
      best_setting
    end
  end

  # Places all files in its buckets
  def place_files_in_buckets
    @files.each do |file|
      place_file_in_buckets(file)
    end
  end

  # Places a given file in its buckets
  def place_file_in_buckets(file)
    (0..@band_settings.bands).each do |band|
      @table.add_item(
        file, 
        band_hash(file.signature_vector, band)
        )
    end
  end

  # Returns the sum of exponentials of a band (x1 + x2^2 + x3^3 ... )
  def band_hash(vector, band)
    rows_per_band = @band_settings.rows
    sub_vector = vector[band * rows_per_band , rows_per_band]

    hash_values = sub_vector.each_with_index.map do |value, index| 
       Zlib.crc32((value ** (index + 1)).to_s)
    end

    hash_values.inject(:+)
  end

  # Class for band-row setting
  class BandSetting

    attr_reader :bands, :rows, :probability

    def initialize(bands, rows, probability)
      @bands       = bands
      @rows        = rows
      @probability = probability
    end

  end

end
