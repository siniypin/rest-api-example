class Review < ActiveRecord::Base
  attr_accessor :title, :text
  belongs_to :user

  validates_presence_of :title, :text, :user
  has_many :comments
end
