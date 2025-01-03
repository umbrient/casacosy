class AddonOption < ApplicationRecord
  belongs_to :addon


  def type 
    if self.quantifiable?
      'number'
    elsif self.booleanable?
      'boolean'
    elsif self.textable?
      'text'
    end
  end
end
