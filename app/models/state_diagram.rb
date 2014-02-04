class StateDiagram
  def initialize circuit
    @circuit = circuit
    @num_ins = circuit.get_num_ins
    @num_ffs = circuit.get_num_ffs
    @inputs = circuit.get_inputs
    @outputs = circuit.get_outputs
  end
  
  def generate_state_diagram
    i = 0
    max_i = 2**@num_ffs
    res = Hash.new
    while i < max_i do
      current_state = (("%0" + @num_ffs.to_s + "b") % i).split(//)
      res_states = Hash.new
      j = 0
      max_j = 2**@num_ins
      while j < max_j do
        cur_j = (("%0" + @num_ins.to_s + "b") % j)
        inputs = cur_j.split(//)
        res_ins = @circuit.evaluate(inputs, current_state)
        m = true
        res_ins[1].each do |state|
          if state == "Don't Care"
            m = false
          end
        end
        if m
          res_states[cur_j] = res_ins
        end
        j = j + 1
      end
      res["S" + i.to_s] = res_states
      i = i + 1
    end
    @state_diagram = res
    true
  end
  
  def generate_text
    max_i = 2**@num_ffs
    res = "STATES_NO:" + max_i.to_s + "\nSTATES:"
    i = 0
    while true do
      res = res + " " + "S" + i.to_s
      if i < max_i - 1
        res = res + ","
      else
        break
      end
      i = i + 1
    end
    res = res + "\nSTATE_DIAGRAM:\n"
    @state_diagram.each do |state, ins|
      res = res + state + ":\n"
      ins.each do |inputs,soln|
        in_array = inputs.split(//)
        max_i = in_array.size
        i = 0
        while true do
          res = res + @inputs[i] + "=" + in_array[i].to_s #
          if i < max_i-1
            res = res + ","
          else
            break
          end
          i = i + 1
        end
        temp = bool_to_binary soln[1]
        res = res + " -> S" +  temp.to_s
        i = 0
        max_i = soln[0].size
        while i < max_i do
          if soln[0][i]
            temp = "1"
          else
            temp = "0"
          end
          res = res + "," + @outputs[i] + "=" + temp
          i = i + 1
        end
        res = res + "\n"
      end
    end
    res
  end
  
  def bool_to_binary bool
    res = ""
    bool.each do |n|
      if n
        res = res + "1"
      else
        res = res + "0"
      end
    end
    res.to_i(2) # This converts the binary state number into decimal one.
  end
  
end