class SchedulesMapper < ROM::Mapper
  relation :schedules
  register_as :schedules

  step do
    ungroup entries: %w(title authors video date start_time end_time break)
  end

  step do
    attribute :title, from: "title"
    attribute :authors, from: "authors"
    attribute :video, from: "video"
    attribute :date, from: "date"
    attribute :start_time, from: "start_time"
    attribute :end_time, from: "end_time"
    attribute :break, from: "break"
  end

  step do
    exclude :conference
    exclude :year
  end

  step do
    group entries: %i(title authors video start_time end_time break)
  end

  step do
    attribute :date do |attr|
      Date.parse(attr)
    end
  end
end
