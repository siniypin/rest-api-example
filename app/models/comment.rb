class Comment < ActiveRecord::Base
  belongs_to :review
  belongs_to :user

  validates_presence_of :text, :user, :review
end
