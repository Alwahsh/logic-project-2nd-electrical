class Circuit < ActiveRecord::Base
  
  def evaluate input
    circuit = CircuitSolver.new(input)
    if circuit.parse
      state_diagram = StateDiagram.new(circuit)
    end
    if state_diagram.generate_state_diagram
      return [state_diagram.generate_text, circuit.get_my_input]
    end
  end
  
end
