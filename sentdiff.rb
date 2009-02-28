#!/usr/bin/env ruby

# Splits paragraphs into sentences, then runs diff on those
# =Why?
# When you're diffing on written text, rather than code, you often have pretty long paragraphs. Often, you've made changes on every paragraph, or nearly every one. This makes diff pretty useless. 
# Author::    Daniel Jackoway (mailto:danjdel@gmail.com)
# Copyright:: Copyright (c) 2009 Daniel Jackoway
# License::   Distributes under the MIT License (see COPYING file)

class String
  # like #split, but keeps the part that you're splitting on. 
  # [pattern] The pattern (a String or Regexp) matched based on.
  # [before?] If true, it keeps the spiltting part with the part before the split point. If false, it goes with the part after the split point. 
  def split_keep(pattern, before = true)
    if pattern.class==String
      pattern = Regexp.new(pattern)
    elsif pattern.class !=Regexp
      raise ArgumentError, "Your splitting pattern must be a String or Regexp"
    end

    arr = []
    str = self
    while ind = pattern =~ str
      match = str[0...ind]
      if before
        match << $&
        str = str[(ind+$&.length)..-1]
      else
        str = str[ind..-1]
      end
    end
  end
end

class Array
  def rand_val
    self[rand(self.length)]
  end
end

rand_chars = []
(a..z).each do |char|
  rand_chars << char
end
(0..9).each do |char|
  rand_chards << char
end

# gives num random letters or numbers
# [num] the length of randcars you want in the string
def randchars(num = 1)
  return "" if num < 1
  return rand_chars.rand_val
end
    
    
    

files = []

files << File.read(ARGV[0])
files << File.read(ARGV[1])

splitfiles = []

files.each do |file|
  splitfiles << file.split_keep(/[\.!\?]/)
end

fnames = []
2.times do |i|
  "#{ARGV[i]}-sdiff-#{rand_chars(5)}"
end





