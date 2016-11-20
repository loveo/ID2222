# Read files from arguments
class FileReader

  # Reads files from argv
  def self.read_from_argv
    read_files(ARGV)
  end

  # Returns a list of Comparison Files from a list of file names
  def self.read_files(file_names)
    queue = create_work_queue(file_names)
    read_files = Queue.new
    workers = []

    (1 .. Settings::CONFIG.pool_size).each do
      workers << Thread.new { threaded_read_file(queue, read_files) }
    end

    workers.each(&:join)
    queue_to_array(read_files)
  end

  private

  # Worker method for readinf files
  def self.threaded_read_file(queue, files)
    begin
      while file = queue.pop(true)
        files << read_file(file)
      end
    rescue ThreadError
    end
  end

  # Returns all files from input file or folders
  def self.find_files(file_names)
    file_names.map { |file_name| peek(file_name) }.flatten.compact
  end

  # Creates a Comparison File from a file name
  def self.read_file(file_name)
    file_contents = File.open(file_name, 'rb') { |file| file.read }
    ComparisonFile.new(file_name, file_contents)
  end

  # Turns a synchronous queue to an array
  def self.queue_to_array(queue)
    queue.size.times.map { queue.pop }
  end

  # Creates a queue of files to process
  def self.create_work_queue(file_names)
    queue = Queue.new

    find_files(file_names).each { |file_name| queue << file_name }

    queue
  end

  # Peeks at a file and returns all it sub-files, itself or nil
  def self.peek(file_name)
    if File.exists?(file_name)
      if File.directory?(file_name)
        (Dir.entries(file_name) - ['.', '..']).map do |file|
          peek("#{file_name}/#{file}")
        end
      else
        file_name
      end
    else
      nil
    end
  end

end
