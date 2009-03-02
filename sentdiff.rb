#!/usr/bin/env ruby

# Splits paragraphs into sentences, then runs diff on those
# =Why?
# When you're diffing on written text, rather than code, you often have pretty long paragraphs. Often, you've made changes on every paragraph, or nearly every one. This makes diff pretty useless. 
# Author::    Daniel Jackoway (mailto:danjdel@gmail.com)
# Copyright:: Copyright (c) 2009 Daniel Jackoway
# License::   Distributes under the MIT License (see COPYING file)

class String
  # like #split, but keeps the part that you're splitting on. 
  # keeps most after.
  # [pattern] The pattern (a String or Regexp) matched based on.
  # [num_before] this number of chars matched will be kept in the piece before the split. The rest go after. 
  def split_keep_after(pattern, num_before = 0)
    if pattern.class==String
      pattern = Regexp.new(pattern)
    elsif pattern.class !=Regexp
      raise ArgumentError, "Your splitting pattern must be a String or Regexp"
    end

    arr = []
    str = self
    while ind = pattern =~ str
      match = str[0...ind+num_before]
      str = str[(ind+num_before)..-1]
      arr << match
    end
    arr << str
    arr
  end
end

class Array
  def rand_val
    self[rand(self.length)]
  end
end

$rand_chars = []
("a".."z").each do |char|
  $rand_chars << char
end
("0".."9").each do |char|
  $rand_chars << char
end

# gives num random letters or numbers
# [num] the length of randcars you want in the string
def random_chars(num = 1)
  return "" if num < 1
  return $rand_chars.rand_val + random_chars(num-1)
end

def file_with_split_sentences(old)
  contents = File.read(old).split_keep_after(/[\.!\?] *[A-Z\n]/, 2)
  begin newname = "#{old}-sdiff-#{random_chars 5}"; end while File.exists?(newname)
  File.open(newname, "w") { |file| file.write contents.join("\n")}
  newname
end

fnames = ARGV[-2..-1].collect{|f| file_with_split_sentences f.chomp}
system "diff #{ARGV[0...-2].join " "} #{fnames.join " "}"
#`rm #{fnames.join " "}`
