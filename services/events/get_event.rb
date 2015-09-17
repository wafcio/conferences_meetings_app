class GetEvent
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def call
    element = ROM.env.relation(:events).by_id(id).one!
    element[:start_date] = Date.strptime("#{element[:start_date]}.#{element[:year]}", '%d.%m.%Y')
    element[:end_date] = Date.strptime("#{element[:end_date]}.#{element[:year]}", '%d.%m.%Y')
    element
  end

  def self.call(id)
    new(id).call
  end
end
