class EventSetSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :instances, :start, :duration, :period
end
