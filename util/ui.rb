require 'curses'

class UI
  def setup
  end

  def clear
    STDOUT.puts "\e[H\e[2J"
  end

  def puts(string)
    STDOUT.puts string
  end
end
