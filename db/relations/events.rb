class Events < ROM::Relation[:csv]
  register_as :events

  def ordered
    order(:conference)
  end

  def with_year(year)
    restrict(year: year)
  end

  def limit_fields(*fields)
    project(*fields)
  end
end
