class AndGate < Gate
  def evaluate
    unless @output.evaluated?
      @output.set_value = @inputs.all? { |input| input.get_value }
    end
    @output.get_value
  end
end