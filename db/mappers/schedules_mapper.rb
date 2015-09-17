class SchedulesMapper < ROM::Mapper
  relation :schedules
  register_as :schedules

  step do
    ungroup entries: %w(title authors date start_time break)
  end

  step do
    attribute :title, from: "title"
    attribute :authors, from: "authors"
    attribute :date, from: "date"
    attribute :start_time, from: "start_time"
    attribute :break, from: "break"
  end

  step do
    exclude :conference
    exclude :year
  end

  step do
    group entries: %i(title authors start_time break)
  end
end
