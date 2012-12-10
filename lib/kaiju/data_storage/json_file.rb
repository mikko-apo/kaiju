require 'json'

class JSONFile < DirectoryBase
  attr_chain :json_default, :require

  def load_latest_data(default=json_default)
    JSONFile.load_json(path, default)
  end

  def edit_data(&block)
    data = load_latest_data
    block.call(data)
    File.safe_write(path, JSON.pretty_generate(data))
    data
  end

  def save(data=cached_data)
    File.safe_write(path, JSON.pretty_generate(data))
  end

  def size
    cached_data.size
  end

  def empty?
    cached_data.empty?
  end

  def include?(key)
    cached_data.include?(key)
  end

  def JSONFile.load_json(path, default=nil)
    if File.exists?(path)
      JSON.parse(IO.read(path))
    else
      default
    end
  end
end

class JSONListFile < JSONFile
  include Enumerable
  attr_chain :json_default, -> { Array.new }
  attr_chain :cached_data, -> { load_latest_data }

  def create_list_item(obj)
    obj
  end

  def add_item(obj)
    edit_data do |list|
      list << obj
    end
    create_list_item(obj)
  end

  def each(&block)
    cached_data.each do |obj|
      block.call(create_list_item(obj))
    end
  end
end

class JSONHashFile < JSONFile
  include Enumerable
  attr_chain :json_default, -> { Hash.new }
  attr_chain :cached_data, -> { load_latest_data }
end