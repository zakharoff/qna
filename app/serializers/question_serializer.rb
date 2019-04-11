class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :files
  has_many :comments
  has_many :links

  def files
    object.files.collect{ |f| Rails.application.routes.url_helpers.rails_blob_path(f, only_path: true) }
  end
end
