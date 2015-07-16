require 'rails_helper'

describe EventsController do
  before(:each) do
    @user = User.create(default_calendar: nil, email: 'test@test.com', password: '12345678')
    allow(controller).to receive(:current_user) {@user}
    sign_in :user, @user
  end

  describe 'post embedded_index' do
    it 'assigns @day' do
      day = (Date.today - 1.day)
      post :embedded_index, date: day.to_s, :format => 'js'
      expect(assigns(:day)).to eq day
    end
    it 'assigns @events' do
      e = double('Event')
      expect(@user).to receive(:appointments) {[e]}
      day = (Date.today - 1.day)
      post :embedded_index, date: day.to_s, :format => 'js'
      expect(assigns(:events)).to eq [e]
    end
  end

  describe 'post embedded_edit' do
    it 'assigns @event' do
      e = double('Event')
      expect(Event).to receive(:find).with('1') {e}
      post :embedded_edit, id: 1, :format => 'js'
      expect(assigns(:event)).to eq e
    end
  end

  describe 'post embedded_new' do
    it 'generates @event and assigns default calendar' do
      c = UserCalendar.create(name: 'Test', visibility: 'LIMITED')
      e = double('Event')
      expect(@user).to receive(:default_calendar) {[c]}
      expect(Event).to receive(:new) {e}
      expect(e).to receive(:user_calendar=) {true}
      post :embedded_new, :format => 'js'
      expect(assigns(:event)).to eq e
    end
  end

  describe 'post embedded_create' do
    it 'creates the event' do
      t = Time.now
      params = {title: 'Title',
                description: 'description',
                notes: 'notes',
                start_at: t.to_s,
                end_at: (t + 30.minutes).to_s}
      e = double('Event',start_at: t.to_s )
      expect(Event).to receive(:create) {e}
      expect(@user).to receive(:appointments) {[e]}
      post :embedded_create, event: params, :format => 'js'
      expect(assigns(:events)).to eq [e]
    end
  end

  describe 'post embedded_update' do
    it 'updates the event' do
      t = Time.now
      params = {title: 'Title',
                description: 'description',
                notes: 'notes',
                start_at: t.to_s,
                end_at: (t + 30.minutes).to_s}
      e = double('Event',start_at: t.to_s )
      expect(Event).to receive(:find) {e}
      expect(e).to receive(:update_attributes) {true}
      expect(@user).to receive(:appointments).twice {[e]}
      post :embedded_update, id: 1,  event: params, :format => 'js'
      expect(assigns(:events)).to eq [e]
    end
  end

end