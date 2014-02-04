class SRFlipFlop < FlipFlop
  def evaluate
    if !@inputs[0].get_value && !@inputs[1].get_value
      @output.get_value
    elsif !@inputs[0].get_value && @inputs[1].get_value
      false
    elsif @inputs[0].get_value && !@inputs[1].get_value
      true
    elsif @inputs[0].get_value && @inputs[1].get_value
      "Don't Care"
    end
  end
end