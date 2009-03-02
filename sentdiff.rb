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

#give a random name for the index-th file to be saved as after being split up
def rand_name(index)
  "#{ARGV[index]}-sdiff-#{random_chars(5)}"
end

# go from array of the params you want to the actual params (basically to_s but w/ spaces)
# [params] The array of paramaters
def shell_params(params)
  str = ""
  params.each do |param|
    str << param << " "
  end
  str 
end
  
    

#start main
raise ArgumentError, "I need 2 filenames to diff!" if ARGV.length < 2
filestrs = []

filestrs << File.read(ARGV[-2].chomp)
filestrs << File.read(ARGV[-1].chomp)

splitfiles = []

filestrs.each do |file|
  splitfiles << file.split_keep_after(/[\.!\?] *[A-Z\n]/, 2)
end


fnames = []
2.times do |i|
  fnames << rand_name((i==0)?(-2):(-1))
end

x = true
while x
  x = false
  fnames.each do |file|
    x = true if File.exists? file
  end
  if x
    fnames.length.times do |i| 
      fnames[i] = rand_name(i)
    end
  end
end

files = []

fnames.each do |fname|
  files << File.open(fname, "w")
end


splitfiles.length.times do |i|
  splitfiles[i].each do |line|
    files[i] << line << "\n"
  end
end

files.each do |file|
  file.close
end

diff_params = shell_params(ARGV[0...-2])
x = "diff #{diff_params} #{fnames[0]} #{fnames[1]}"
system x
%x[rm #{fnames[0]} #{fnames[1]}]

