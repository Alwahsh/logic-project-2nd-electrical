class CircuitsController < ApplicationController
  before_action :set_circuit, only: [:show, :edit, :update, :destroy]

  # GET /circuits
  # GET /circuits.json
  def index
    @circuits = Circuit.all
  end

  # GET /circuits/1
  # GET /circuits/1.json
  def show
  end

  # GET /circuits/new
  def new
    @circuit = Circuit.new
  end

  # GET /circuits/1/edit
  def edit
  end

  # POST /circuits
  # POST /circuits.json
  def create
    @circuit = Circuit.new(circuit_params)
    temp = @circuit.evaluate(@circuit.input)
    @circuit.output = temp[0]
    @circuit.input = temp[1]
    if params[:required]
        @circuit.required = true
      else
        @circuit.required = false
      end
    respond_to do |format|
      if @circuit.save
        format.html { redirect_to @circuit, notice: 'Circuit was successfully evaluated and saved.' }
        format.json { render action: 'show', status: :created, location: @circuit }
      else
        format.html { render action: 'new' }
        format.json { render json: @circuit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /circuits/1
  # PATCH/PUT /circuits/1.json
  

  def download_input
    circuit = Circuit.find(params[:id])
    send_data circuit.input,
              :filename => "#{circuit.id}_input.txt",
              :type => "text/plain"
  end
  
  def download_output
    circuit = Circuit.find(params[:id])
    send_data circuit.output,
              :filename => "#{circuit.id}_output.txt",
              :type => "text/plain"
  end
  
  def upload
    @circuit = Circuit.new
    @circuit.input = params[:input].read
    temp = @circuit.evaluate(@circuit.input)
    @circuit.output = temp[0]
    @circuit.input = temp[1]
    if params[:required]
      @circuit.required = true
    else
      @circuit.required = false
    end
    respond_to do |format|
      if @circuit.save
        format.html { redirect_to @circuit, notice: 'Circuit was successfully evaluated and saved.' }
        format.json { render action: 'show', status: :created, location: @circuit }
      else
        format.html { render action: 'new' }
        format.json { render json: @circuit.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /circuits/1
  # DELETE /circuits/1.json

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_circuit
      @circuit = Circuit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def circuit_params
      params.require(:circuit).permit(:input, :output, :required)
    end
end
