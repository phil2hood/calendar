require 'rails_helper'

describe UserCalendar do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_inclusion_of(:visibility).in_array(UserCalendar:: VISIBILITY_LEVELS)}
  end
end