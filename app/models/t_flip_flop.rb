class TFlipFlop < FlipFlop
  def evaluate
    if @inputs[0].get_value
      !@output.get_value
    else
      @output.get_value
    end
  end
end