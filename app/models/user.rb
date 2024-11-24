class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role
  has_many :requests


  def is_admin? 
    role.name.downcase == 'admin'
  end

  def is_manager? 
    role.name.downcase == 'manager'
  end



end


