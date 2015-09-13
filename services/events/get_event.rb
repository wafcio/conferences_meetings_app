class GetEvents
  attr_reader :year

  def initialize(year)
    @year = year
  end

  def call
    collection = ROM.env.relation(:events).with_year(year).ordered.to_a
    collection = collection.map do |element|
      element[:start_date] = Date.strptime("#{element[:start_date]}.#{element[:year]}", '%d.%m.%Y')
      element[:end_date] = Date.strptime("#{element[:end_date]}.#{element[:year]}", '%d.%m.%Y')
      element
    end

    collection = collection.sort { |a, b| a[:start_date] <=> b[:start_date] }
    # collection = collection.group_by{ |d| d[:start_date].strftime('%m').to_i }
    collection
  end

  def self.call(year)
    new(year).call
  end
end
