class Comment < ActiveRecord::Base
  attr_accessor :text
  belongs_to :review
  belongs_to :user

  validates_presence_of :text, :user, :review
end
