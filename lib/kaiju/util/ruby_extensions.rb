# -*- encoding: utf-8 -*-

module KaijuEnumerable
  # enforces size constraints, returns self
  def size!(*args)
    args.each do |valid_size|
      if valid_size.kind_of?(Range)
        if valid_size.include?(size)
          return self
        end
      elsif valid_size.respond_to?(:to_i)
        if valid_size.to_i == size
          return self
        end
      else
        raise "'#{valid_size.inspect}' not supported, needs to be either Range or have .to_i method"
      end
    end
    raise "size #{size} does not match '#{args.map { |s| s.to_s }.join("', '")}'"
  end

  # If any of the enumerable's patterns matches the value returns the matching pattern
  def any_matches?(value)
    each do |pattern|
      if value.match(pattern)
        return pattern
      end
    end
    false
  end

  # Returns n first items from enumerable
  # * if block is given, uses block to decide if item is included
  def find_first(count=1, &block)
    ret = []
    each do |item|
      if block.nil? || block.call(item)
        ret << item
        if ret.size == count
          break
        end
      end
    end
    if count==1
      ret.at(0)
    else
      ret
    end
  end

  # Makes a hash out of the enumerable by going through each item and splits it.
  def to_h(separator=nil, &block)
    ret = {}
    each do |item|
      if separator
        key, *values = item.split(separator)
        if values.size > 0 || item.include?(separator)
          ret[key]=values.join(separator)
        else
          ret[key]=true
        end
      elsif block
        key, value = block.call(item)
        ret[key]=value
      end
    end
    ret
  end

end

class Array
  include KaijuEnumerable
end

module Enumerable
  include KaijuEnumerable
end

require 'fileutils'
class File
  # writes a temp file next to the real file and renames the temp file once it's complete
  def File.safe_write(dest, txt=nil, &block)
    tmp = dest + "-" + rand(9999).to_s
    File.open(tmp, "w") do |file|
      if block
        block.call(file)
      elsif txt
        file.write(txt)
      end
    end
    FileUtils.mv(tmp, dest)
  end
end

class Hash

  # improved [](), default value can be set on the spot with value or block
  def get(key, default=nil, &block)
    value = self[key]
    if value || include?(key)
      value
    elsif block
      block.call
    else
      default
    end
  end

  # improved fetch(), warns about missing key by displaying the missing key name
  def require(key)
    if !include?(key)
      raise "'#{key}' is not defined!"
    end
    self[key]
  end
end


