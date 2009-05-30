#!/usr/bin/env ruby

class Formatter
  TOP = 0
  SECOND = 1
  THIRD = 2
  
  def initialize(max_heading_level=3)
    @max_heading_level = max_heading_level
  end

  def format(line)
    cols = split_by_tab(line)
    content = extract_content(cols)
    level = indent_level(cols)
    format_line(level, content)
  end

  protected

  def make_heading(level, content)
    content
  end

  def make_list(level, content)
    content
  end

  def format_line(level, content)
    if level <= (@max_heading_level - 1)
      make_heading(level + 1, content)
    else
      make_list(level, content)
    end

#     case level
#     when TOP
#       return format_as_top_level(content)
#     when SECOND
#       return format_as_second_level(content)
#     when THIRD
#       return format_as_third_level(content)
#     else
#       return format_as_lower_level(content, level)
#     end
  end

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

  protected

  def make_heading(level, content)
    case level
    when 1
      make_title(content)
    when 2
      make_rst_heading('=', content)
    when 3 
      make_rst_heading('-', content)
    else
    end
  end

  def make_list(level, content)
    " #{'  ' * (level - 3)}* #{content}\n\n"
  end

  def make_title(content)
    text = ''
    text << "=" * (content.size * 1.5) << "\n"
    text << content << "\n"
    text << "=" * (content.size * 1.5) << "\n"
    text << "\n\n"
  end

  def make_rst_heading(char, content)
    text = ''
    text << content << "\n"
    text << char * (content.size * 1.5)
    text << "\n\n"
  end
end

class TracFormatter < Formatter

  protected

  def make_heading(level, content)
    "#{'=' * level}#{content}#{'=' * level}"
  end

  def make_list(level, content)
    "#{' ' * (level - 3)}* #{content}\n"
  end
end

class RedmineFormatter < Formatter

  protected

  def make_heading(level, content)
    "h#{level}. #{content}\n"
  end

  def make_list(level, content)
    "#{' ' * (level - 3)}* #{content}\n"
  end
end

class MindmapToTextFormatter

  def initialize(file, type)
    @file = file
    @type = type
    @formatters = init_formatters
    @formatter = nil
  end

  def init_formatters
    formatters = {}
    formatters[:rest] = ReSTFormatter.new
    formatters[:redmine] = RedmineFormatter.new
    formatters[:trac] = TracFormatter.new
    formatters
  end

  def run
    @formatter = @formatters[@type]
    if @formatter.nil?
      puts "Error: select valid formatter #{@formatters.keys.join(',')}"
      exit(1)
    end

    open(@file, 'r').each do |f|
      f.each_line do |line|
        puts @formatter.format(line.chomp)
      end
    end
  end
end

file = ARGV[0]
type = ARGV[1]

if file.nil?
  puts "Usage: mm2txt.rb filename [rest|redmine|trac]"
  exit(1)
end
if type.nil?
  type = :rest
else
  type = type.to_sym
end

mm2txt = MindmapToTextFormatter.new(file, type)
mm2txt.run

