#!/usr/bin/env ruby

class Formatter
  TOP = 0
  SECOND = 1
  THIRD = 2

  protected

  def format_as_top_level(content)
    content
  end
  def format_as_second_level(content)
    content
  end
  def format_as_third_level(content)
    content
  end
  def format_as_lower_level(content)
    content
  end

  def split_by_tab(line)
    line.split("\t")
  end

  def extract_content(cols)
    cols[cols.count-1]
  end

  def indent_level(cols)
    cols.count{|c| c==""} 
  end


end

class ReSTFormatter < Formatter


  def format(line)
    cols = split_by_tab(line)
    content = extract_content(cols)
    level = indent_level(cols)
    case level
    when TOP
      return format_as_top_level(content)
    when SECOND
      return format_as_second_level(content)
    when THIRD
      return format_as_third_level(content)
    else
      return format_as_lower_level(content, level)
    end
  end

  protected

  def format_as_top_level(content)
    text = ''
    text << "=" * (content.size * 1.5) << "\n"
    text << content
    text << "=" * (content.size * 1.5) << "\n"
    text << "\n\n"
  end

  def format_as_second_level(content)
    text = ''
    text << content
    text << "=" * (content.size * 1.5)
    text << "\n\n"
  end

  def format_as_third_level(content)
    text = ''
    text << content
    text << "-" * (content.size * 1.5)
    text << "\n\n"
  end

  def format_as_lower_level(content, indent_level)
    text = ''
    text << " "
    text << "  " * (indent_level - 2)
    text << "* "
    text << content
    text << "\n"
  end


end

class RedmineFormatter < Formatter
end

def format_as_tabbed_text(line)
  formatter = ReSTFormatter.new
  formatter.format(line)
end

file = ARGV[0]
if file.nil?
  puts "Usage: mm2txt.rb textfile"
  exit(1)
end

open(file, 'r').each do |f|
  f.each_line do |line|
    puts format_as_tabbed_text(line)
 end
end


