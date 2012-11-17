require 'curses'

class UI
  KEY_UP = Curses::KEY_UP
  KEY_DOWN = Curses::KEY_DOWN
  KEY_LEFT = Curses::KEY_LEFT
  KEY_RIGHT = Curses::KEY_RIGHT

  attr_reader :on_key_callback

  def initialize
    @line = 0
    @column = 0
  end

  def on_key(&block)
    @on_key_callback = block
  end

  def start(&block)
    Curses.noecho
    Curses.init_screen
    Curses.timeout = 0
    Curses.stdscr.keypad(true)

    begin
      ui = self
      x = Thread.new do
        loop do
          if key = Curses.getch
            ui.on_key_callback.call key
          end
        end
      end
      x.abort_on_exception = true

      yield(self)
    ensure
      Curses.close_screen
    end
  end

  def reset
    @line = 0
    @column = 0
  end

  def puts(value)
    value = if value.kind_of?(String)
               value
            else
               value.inspect
            end

    write @line, @column, value

    @line = @line + value.count("\n")
  end

  def write(line, column, text)
    Curses.setpos(line, column)
    Curses.addstr(text)
    Curses.refresh
  end

  def draw
  end
end
