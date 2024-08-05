class Message < ApplicationRecord
  validates :name, presence: true
  validates :data, presence: true
end
