class UserCalendarSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :color, :visibility
end
