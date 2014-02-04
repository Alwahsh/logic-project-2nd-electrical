class Internal
  def initialize
    @evaluated = false
  end

  # Get the value of the internal.
  def get_value
    # If it is evaluated then just return the value.
    if @evaluated
      @value
    # If it is not evaluated then evaluate it, save and return the value.
    else
      @value = @parent.evaluate
      @evaluated = true
      @value
    end
  end

  # Set the value of the internal and makes it evaluated.
  def set_value= val
    @value = val
    @evaluated = true
  end

  def set_parent= parent
    @parent = parent
  end
  
  def get_parent
    @parent
  end
  
  def reset
    @evaluated = false
  end
  
  def evaluated?
    @evaluated
  end
end