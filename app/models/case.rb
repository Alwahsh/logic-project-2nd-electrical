class Case < ActiveRecord::Base
  
  # This was for testing purposes... No use in production.
  # Note: Internal Xdash is different than internal XDASH.
  # For Flip Flops that have 2 inputs... The first input should be the first one in the name of the FF.
  # Example: First input of a JK Flip Flop is J and second one is K.
  
  def self.evaluate_circuit(input)
    circuit = Circuit.new(input)
    if circuit.parse
      circuit.get_output
    else
      false
    end
  end

  def self.test_2
    something = "FF_TYPE: JK\nFF_NO: 2\nINPUT_NO: 1\nOUTPUT_NO: 1\nINTERNAL_NO: 7\nINPUTS: X\nOUTPUTS: Z\nINTERNALS: Xdash, J1, K1, J0, K0, Q1, Q0\nDESIGN:\nINVERTER(X,Xdash)\nGATE: AND (Xdash,Q0,J1)\nGATE: OR(X,Q0,K1)\nGATE: OR(X,Q1,J0)\nGATE: AND(Q1,Q0,Z)\nFF: JK(J1,K1,Q1)\nFF: JK(J0,K0,Q0)\nINVERTER(X,K0)"
    file = File.open("input.txt", "rb")
    something = file.read
    file.close
    circuit = Circuit.new(something)
    if circuit.parse
      state_diagram = StateDiagram.new(circuit)
    end
    if state_diagram.generate_state_diagram
      puts state_diagram.generate_text
    end
    true
  end

=begin
def self.test_me
i1 = Internal.new(false,true)
r1 = Inverter.new(i1)
r2 = Inverter.new(r1.get_output)
r3 = Inverter.new(r2.get_output)
puts r2.evaluate
puts r3.evaluate
end
=end

end
