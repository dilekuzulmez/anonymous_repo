json.cache! [@stadium], expires_in: 1.hour do
  json.call(@stadium, :id, :name)
end
