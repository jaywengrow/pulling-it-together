class Employee < ActiveRecord::Base
  validates :email, presence: true
end
