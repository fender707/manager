class DirectorySerializer < ActiveModel::Serializer
  attributes :id, :title, :parent_directory_id
end
