class DFlipFlop < FlipFlop
  def evaluate
    @inputs[0].get_value
  end
end