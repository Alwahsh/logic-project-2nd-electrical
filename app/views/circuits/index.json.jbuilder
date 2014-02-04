json.array!(@circuits) do |circuit|
  json.extract! circuit, :id, :input, :output, :required
  json.url circuit_url(circuit, format: :json)
end
