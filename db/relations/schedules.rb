class Schedules < ROM::Relation[:json]
  register_as :schedules
  gateway :schedules

  def for_conference(conference, year)
    restrict(conference: conference, year: year.to_s)
  end
end
