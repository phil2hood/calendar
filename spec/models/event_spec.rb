require 'rails_helper'

describe Event do
  describe 'validations' do
    it { should validate_presence_of :title }
  end

  describe 'start_at' do
    it 'should use attribute if not null' do
       t = Time.now + 45.minutes
       e = Event.create(title: 'Title',
                        description: 'description',
                        notes: 'notes',
                        start_at: t,
                        end_at: t + 30.minutes)
       expect(e.start_at).to eq(t)
    end
    it 'should now if not null' do
      t = Time.now + 5.minutes
      e = Event.create(title: 'Title',
                       description: 'description',
                       notes: 'notes')
      expect(e.start_at).to be < t
    end
  end

  describe 'start_at' do
    it 'should use attribute if not null' do
      t = Time.now + 45.minutes
      e = Event.create(title: 'Title',
                       description: 'description',
                       notes: 'notes',
                       start_at: t,
                       end_at: t + 30.minutes)
      expect(e.end_at).to eq(t + 30.minutes)
    end
    it 'should now + 30 if not null' do
      t = Time.now + 5.minutes
      e = Event.create(title: 'Title',
                       description: 'description',
                       notes: 'notes')
      expect(e.start_at).to be < (t + 30.minutes)
    end
  end

end