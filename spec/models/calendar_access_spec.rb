require 'rails_helper'

describe CalendarAccess do
  describe 'validations' do
    it { should validate_inclusion_of(:access_level).in_array(CalendarAccess::  ACCESS_LEVELS)}
  end
end