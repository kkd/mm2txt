#!/usr/bin/env ruby

def format_as_tabbed_text(line)
  text = ''
  cols = line.split("\t")
  strings = cols[cols.count-1]
  count_of_tabs = cols.count{|c| c==""} 

  case count_of_tabs
  when 0
    text << "=" * (strings.size * 1.5) << "\n"
    text << strings
    text << "=" * (strings.size * 1.5) << "\n"
    text << "\n\n"
  when 1
    text << strings
    text << "=" * (strings.size * 1.5)
    text << "\n\n"
  when 2
    text << strings
    text << "-" * (strings.size * 1.5)
    text << "\n\n"
  else
    text << " "
    text << "  " * (count_of_tabs - 2)
    text << "* "
    text << strings
    text << "\n"
  end
  return text
end
file = ARGV[0]
if file.nil?
  puts "Usage: jude2txt.rb textfile"
  exit(1)
end

open(file, 'r').each do |f|
  f.each_line do |line|
    puts format_as_tabbed_text(line)
 end
end


