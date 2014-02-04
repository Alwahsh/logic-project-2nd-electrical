class FlipFlop
  def initialize inputs, output
    @inputs = inputs
    @output = output
    @output.set_parent = self
  end
end