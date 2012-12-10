#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

def find_ideal_source_order(source)
  smallest_bits_needed = 1000
  c = 0
  source.chars.to_a.permutation(source.size).each do |p|
    c += 1
    alpha = p.join("")
    i = make_index(alpha)
    bits_needed = calculate_bits_needed_index_value("hello world", i)
    if bits_needed < smallest_bits_needed
      smallest_bits_needed = bits_needed
      puts "Found smaller bits needed (#{smallest_bits_needed}): '#{alpha}'"
      calculate_bits_needed_index_value("hello world", i, true)
    end
    bits_needed = calculate_bits_needed_delta_index_value("hello world", i)
    if bits_needed < smallest_bits_needed
      smallest_bits_needed = bits_needed
      puts "Found smaller bits needed with delta (#{smallest_bits_needed}): '#{alpha}'"
      calculate_bits_needed_delta_index_value("hello world", i, true)
    end
  end
  puts c
end

def calculate_bits_needed_index_value(s, i, print=false)
  c = 0
  biggest_index = -1
  while c < s.size
    t = s[c..c+1]
    if t.size == 1
      t += " "
    end
    index = i.index(t)
    if index > biggest_index
      biggest_index = index
    end
    if print
      puts "#{t}=#{index}"
    end
    c += 2
  end
  if print
    puts "Biggest index #{biggest_index} needs #{calculate_bits_needed(biggest_index)} bits and 6 items need #{6*calculate_bits_needed(biggest_index)} bits"
  end
  calculate_bits_needed(biggest_index) * 6
end

def calculate_bits_needed(i)
  bits = 0
  while i > 0
    bits += 1
    i = i >> 1
  end
  bits
end

def calculate_bits_needed_delta_index_value(s, i, print=false)
  c = 0
  t = s[0..1]
  previous_index = first_index = i.index(t)
  if print
    puts "#{t}=#{first_index}"
  end
  biggest_delta = -1
  c = 2
  needs_positive = needs_negative = false
  deltas = [first_index]
  while c < s.size
    t = s[c..c+1]
    if t.size == 1
      t += " "
    end
    index = i.index(t)
    delta_index = index - previous_index
    deltas << delta_index
    if delta_index > 0
      needs_positive = true
    end
    if delta_index < 0
      needs_negative = true
    end
    if delta_index.abs > biggest_delta
      biggest_delta = delta_index.abs
    end
    if print
      puts "#{t}=#{index} #{delta_index}"
    end
    previous_index = index
    c += 2
  end
  if print
    puts "Delta first #{calculate_bits_needed(first_index)} + 5 * #{(calculate_bits_needed(biggest_delta) + (needs_positive != needs_negative ? 0 : 1) )} bits"
    puts "Deltas: #{deltas.join(", ")}"
    puts "Num: #{deltas.reverse.inject(0){|num, n| num << 4 | n}}"

  end
  calculate_bits_needed(first_index) + 5 * (calculate_bits_needed(biggest_delta) + (needs_positive != needs_negative ? 0 : 1) )
end

def make_index(source)
  source.chars.to_a.repeated_permutation(2).to_a.map{|a| a.join("")}
end

source = "helowrd "
# find_ideal_source_order(source)

#i=0;puts (0..5).map{|j|'hloewrd '.chars.to_a.repeated_permutation(2).to_a[i+=15187555>>j*4&15]}.join("")



















puts ((i=0)..5).map{|j|'hloewrd '.scan(/./).repeated_permutation(2).to_a[i+=0xe7be63>>j*4&15]}.join




























# I wanted to include as many confusing programming concepts as possible:
# - pre calculated magic values
# - compression
# - lookup table with procedural generation from permutations
# - delta encoding and accumulator
# - bitwise operations
# - operator precedence
# - regular expressions
# - confusing syntax
