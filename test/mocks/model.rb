class Model < Struct.new(:one, :two)
  def initialize(one, two)
    self .one = one
    self.two = two
  end
end