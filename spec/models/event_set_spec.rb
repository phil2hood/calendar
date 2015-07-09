require 'rails_helper'

describe EventSet do
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :duration }
    it { should validate_presence_of :instances }
  end

  describe 'start_at' do
    it 'should use attribute if not null' do
      t = Time.now + 45.minutes
      e = EventSet.create(title: 'Title',
                       duration: 45,
                       period: 7,
                       instances: 3,
                       start_at: t)
      expect(e.start_at).to eq(t)
    end
    it 'should now if not null' do
      t = Time.now + 5.minutes
      e = EventSet.create(title: 'Title',
                          duration: 45,
                          instances: 3,
                          period: 7)
      expect(e.start_at).to be < t
    end
  end

end