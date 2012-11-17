class UIBasic
  def start(&block)
    reset
    yield
  end

  def on_key(&block)
  end

  def reset
    STDOUT.puts "\e[H\e[2J"
  end

  def puts(value)
    STDOUT.puts value
  end

  def draw
  end
end
