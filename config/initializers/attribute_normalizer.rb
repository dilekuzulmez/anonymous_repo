AttributeNormalizer.configure do |config|
  config.normalizers[:downcase] = lambda do |value, options|
    value.to_s.downcase
  end

  config.normalizers[:upcase] = lambda do |value, options|
    value.to_s.upcase
  end
end
