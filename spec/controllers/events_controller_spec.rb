require 'rails_helper'

describe EventsController do

  describe 'post embedded_index' do
    it 'assigns @day' do
      u = User.create(default_calendar: nil, email: 'test@test.com', password: '12345678')
      sign_in :user, u
      day = (Date.today - 1.day)
      post :embedded_index, date: day.to_s, :format => 'js'
      expect(assigns(:day)).to eq day
    end
    it 'assigns @events' do
      u = User.create(default_calendar: nil, email: 'test@test.com', password: '12345678')
      e = double('Event')
      allow(controller).to receive(:current_user) {u}
      expect(u).to receive(:appointments) {[e]}
      sign_in u
      day = (Date.today - 1.day)
      post :embedded_index, date: day.to_s, :format => 'js'
    end
  end

  describe 'post embedded_edit' do
    it 'assigns @event' do
      u = User.create(default_calendar: nil, email: 'test@test.com', password: '12345678')
      e = double('Event')
      expect(Event).to receive(:find).with('1') {e}
      sign_in u
      post :embedded_edit, id: 1, :format => 'js'
    end
  end

end