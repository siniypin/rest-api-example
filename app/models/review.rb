class Review < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :text, :user
  has_many :comments, dependent: :delete_all
end
