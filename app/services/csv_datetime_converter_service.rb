# Use by smarter_csv gem
class CsvDatetimeConverterService
  def self.convert(value)
    DateTime.parse(value)
  end
end
