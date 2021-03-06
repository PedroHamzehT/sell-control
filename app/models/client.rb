class Client < ApplicationRecord
  validates_presence_of :name

  has_many :sales, dependent: :destroy
  belongs_to :user
end
