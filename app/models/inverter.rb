class Inverter
  # Initializer takes the input.
  def initialize input, output
    @input = input
    @output = output
    @output.set_parent = self
  end
  
  # Evaluate the output of the inverter.
  def evaluate
    # If the output is already evaluated then return its value.
    if @output.evaluated?
      @output.get_value
    # Output is not evaluated. Evaluate it.
    else
      @output.set_value = !@input.get_value
      @output.get_value
    end
  end
  
end