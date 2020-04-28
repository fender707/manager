class NoteSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :tags, :position
  has_one :directory
  has_one :user
end
