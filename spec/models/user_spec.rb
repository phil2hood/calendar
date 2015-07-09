require 'rails_helper'

describe User do
  describe 'appointment' do
    it 'gets events starting in the day' do
      e = double('Event')
      u = User.new
      allow(EventSet).to receive(:where).and_return double('set', where: [])
      allow(Event).to receive(:where).and_return double('set', where: [e])
      expect(u.appointments(Date.today)).to include(e)
    end

    it 'checks event_sets for inclusion' do
      e = double('Event')
      ev_rel = double('event_rel', where: [])
      es = double('EventSet',
                  start_at: Time.now,
                  duration: 30,
                  period: 7,
                  events:ev_rel,
                  title: 'ES Title',
                  description: 'ES Description',
                  user_calendar_id: 1)
      u = User.new
      expect(EventSet).to receive(:where).and_return double('set', where: [es])
      expect(Event).to receive(:where).and_return double('set', where: [e])
      expect(ev_rel).to receive(:create).and_return e
      expect(u.appointments(Date.today)).to include(e)
    end

  end

  describe 'default_calendar' do
    it 'should use first calendar if nil' do
      u = User.create(default_calendar: nil, email: 'test@test.com', password: '12345678')
      c = UserCalendar.create(:name => 'test', visibility: 'LIMITED')
      ca = u.calendar_accesses.create(user_id: u.id, user_calendar_id: c.id, access_level: 'FULL')
      expect(u.default_calendar).to eq(c)
    end
    it 'should use attribute if not nil' do
      u = User.create(default_calendar: nil, email: 'test@test.com', password: '12345678')
      c = UserCalendar.create(:name => 'test', visibility: 'LIMITED')
      ca = u.calendar_accesses.create(user_id: u.id, user_calendar_id: c.id, access_level: 'FULL')
      c2 = UserCalendar.create(:name => 'test 2', visibility: 'LIMITED')
      ca2 = u.calendar_accesses.create(user_id: u.id, user_calendar_id: c.id, access_level: 'FULL')
      u.default_calendar_id=c2.id
      u.save
      expect(u.default_calendar).to eq(c2)
    end
  end

end