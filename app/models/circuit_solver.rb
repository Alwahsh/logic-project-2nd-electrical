def ff_types
  ["JK","D","T","SR"]
end

class CircuitSolver
  # Initialize the circuit.
  def initialize input
    @input = input.split("\n")
    @my_input = ""
    @current_state_variables = Array.new()
    @next_state_variables = Array.new()
  end

  # Takes inputs and current state and returns output and next state.
  def evaluate inputs, current_state
    reset_circuit
    all_inputs = get_inputs_to_gate @inputs_string
    i = 0
    while i < inputs.size do 
      all_inputs[i].set_value = (inputs[i].to_i == 1)
      i = i + 1
    end
    all_state_vars = get_inputs_to_gate @current_state_variables
    i = 0
    while i < current_state.size do
      all_state_vars[i].set_value = (current_state[i].to_i == 1)
      i = i + 1
    end
    outputs = get_inputs_to_gate @outputs_string
    outputs_res = Array.new
    outputs.each do |output|
      outputs_res << output.get_value
    end
    next_state = Array.new
    all_state_vars.each do |state_var|
      next_state << state_var.get_parent.evaluate
    end
    return outputs_res, next_state
  end
  
  # Resets the circuit so that it can start calculating the next operation at different inputs and/or state.
  def reset_circuit
    @internals.each do |internal|
      internal.reset
    end
  end

  # Parse the input to create different circuit components.
  def parse
    @ff_type = @input[0].match(/FF_TYPE: *([a-zA-Z]+)/)[1].upcase
    false unless ff_types.include? @ff_type
    @my_input = @my_input + "FF_TYPE: " + @ff_type + "\n"
    @ff_no = @input[1].match(/FF_NO: *(\d+)/)[1].to_i
    @my_input = @my_input + "FF_NO: " + @ff_no.to_s + "\n"
    @input_no = @input[2].match(/INPUT_NO: *(\d+)/)[1].to_i
    @my_input = @my_input + "INPUT_NO: " + @input_no.to_s + "\n"
    @output_no = @input[3].match(/OUTPUT_NO: *(\d+)/)[1].to_i
    @my_input = @my_input + "OUTPUT_NO: " + @output_no.to_s + "\n"
    @internal_no = @input[4].match(/INTERNAL_NO: *(\d+)/)[1].to_i
    @my_input = @my_input + "INTERNAL_NO: " + @internal_no.to_s + "\n"
    inputs = @input[5].delete(" ").match(/INPUTS: *([^ ]+)/)
    if inputs
      @inputs_string = internals_parse inputs[1], "INPUTS"
    else
      @inputs_string = []
    end
    outputs = @input[6].delete(" ").match(/OUTPUTS: *([^ ]+)/)
    if outputs
      @outputs_string = internals_parse outputs[1], "OUTPUTS"
    else
      @outputs_string = []
    end
    internals = @input[7].delete(" ").match(/INTERNALS: *([^ ]+)/)
    if internals
      @internals_string = internals_parse internals[1], "INTERNALS"
    else
      @internals_string = []
    end
    create_internals
    @my_input = @my_input + "DESIGN:\n"
    i = 8
    while (true)
      i = i + 1 ;
      break unless @input[i]
      if @input[i].match("INVERTER")
        create_inverter @input[i].delete(' ')
      elsif @input[i].match("GATE")
        create_gate @input[i].delete(' ')
      elsif @input[i].match("FF")
        create_ff @input[i].delete(' ')
      else
      false
      end
    end
    true
  end

  def get_my_input
    @my_input
  end

  def create_ff line
    parsed = line.match(/FF:(.+)\((.+)\)/)
    type = parsed[1].upcase
    internals = parsed[2].split(",")
    @my_input = @my_input + "FF: " + type + "(" + parsed[2] + ")" + "\n"
    output_string = internals.pop
    @current_state_variables << output_string
    @next_state_variables = @next_state_variables + internals
    output = get_internal output_string
    inputs = get_inputs_to_gate internals
    if type == "JK"
      ff = JKFlipFlop.new(inputs,output)
    elsif type == "SR"
      ff = SRFlipFlop.new(inputs,output)
    elsif type == "D"
      ff = DFlipFlop.new(inputs,output)
    elsif type == "T"
      ff = TFlipFlop.new(inputs,output)
    else
      false
    end
  end

  # Creates a gate and assign to it proper inputs and output.
  def create_gate line
    parsed = line.match(/GATE:(.+)\((.+)\)/)
    type = parsed[1].upcase
    internals = parsed[2].split(",")
    @my_input = @my_input + "GATE: " + type + "(" + parsed[2] + ")" + "\n"
    output = get_internal internals.pop
    inputs = get_inputs_to_gate internals
    if type == "AND"
      g = AndGate.new(inputs,output)
    elsif type == "OR"
      g = OrGate.new(inputs,output)
    else
      false
    end
  end

  # Create an inverter and assign to it proper input and output.
  def create_inverter line
    parsed = line.match(/INVERTER\((.+),(.+)\)/)
    # Input is parsed[1] and output is parsed[2]
    input = get_internal parsed[1]
    output = get_internal parsed[2]
    i = Inverter.new(input,output)
    @my_input = @my_input + "INVERTER(" + parsed[1] + "," + parsed[2] + ")" + "\n"
  end

  # Creates an array of all internals.
  def create_internals
    @all_internals_string = @inputs_string + @internals_string + @outputs_string
    @internals = Array.new()
    @inputs_string.each do |input|
      @internals << Internal.new()
    end
    @internals_string.each do |internal|
      @internals << Internal.new()
    end
    @outputs_string.each do |output|
      @internals << Internal.new()
    end
  end
  
  # Returns all inputs.
  def get_inputs
    @inputs_string
  end
  
  # Returns all outputs.
  def get_outputs
    @outputs_string
  end
  
  # Returns number of flip flops.
  def get_num_ffs
    @ff_no
  end
  
  # Returns number of inputs.
  def get_num_ins
    @input_no
  end
  
  # Helper function to easily get inputs to a gate.
  def get_inputs_to_gate internals
    inputs = Array.new
    internals.each do |input|
      inputs << get_internal(input)
    end
    inputs
  end
  
  
  # Helper function to easily get internal objects from internal strings.
  def get_internal internal_string
    @internals[@all_internals_string.index(internal_string)]
  end

  # Helper function to handle the inputs,outputs & internals lines.
  def internals_parse internals, type
    my_internals = internals.split(",").map(&:strip)
    @my_input = @my_input + type + ":"
    res = ""
    my_internals.each do |i|
      res = res + " " + i + ","
    end
    @my_input = @my_input + res[0...-1] + "\n"
    my_internals
  end

end