class GetSchedule
  attr_reader :event

  def initialize(event_id)
    @event = load_event(event_id)
  end

  def call
    ROM.env.relation(:schedules).as(:schedules).for_conference(event[:conference], event[:year]).to_a
  end

  def self.call(event_id)
    new(event_id).call
  end

  private

  def load_event(id)
    ROM.env.relation(:events).by_id(id).one!
  end
end
