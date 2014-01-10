# -*- encoding : utf-8 -*-

class String
  # Cleaner concatenation
  def | other
    self << other
  end
end
