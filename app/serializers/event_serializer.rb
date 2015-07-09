class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :start_at, :end_at, :notes
end
