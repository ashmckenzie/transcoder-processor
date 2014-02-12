class BetterFile

  def initialize path
    @path = path
  end

  def to_s
    "#{directory}/#{filename_without_extension}.#{extension}"
  end

  def directory
    @directory ||= begin
      path.split('/')[0...-1].join('/')
    end
  end

  def directory= new_directory
    @directory = new_directory
  end

  def filename_without_extension
    @filename_without_extension ||= begin
      path.split('/').last.gsub(/\..+$/, '')
    end
  end

  def filename_without_extension= new_filename_without_extension
    @filename_without_extension = new_filename_without_extension
  end

  def extension
    @extension ||= begin
      path.match(/\.(.+)$/)[1]
    end
  end

  def extension= new_extension
    @extension = new_extension
  end

  private

    attr_reader :path

end
