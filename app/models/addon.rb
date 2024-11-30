class Addon < ApplicationRecord

  has_many :addon_options


  def immediately_calculate_price? 
    addon_options.count == 1 ? true : false 
  end

end
