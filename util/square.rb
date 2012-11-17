class Square < Struct.new(:x1, :y1, :x2, :y2)
  def initialize(x1, y1, x2, y2)
    super

    %w(x1 y1 x2 y2).each do |attr|
      if send(attr) < 0
        self.send("#{attr}=", 0)
      end
    end
  end

  def pad(n)
    self.x1 = x1 - n
    self.y1 = y1 - n
    self.x2 = x2 + n
    self.y2 = y2 + n
  end

  def area
    x = (x1..x2).to_a
    y = (y1..y2).to_a

    area = []
    x.length.times do |i|
      y.length.times do |ii|
        area << Point.new(:x => x[i], :y => y[ii])
      end
    end

    area
  end
end
