# -*- encoding : utf-8 -*-
# Is this class pollution?

class Array
  # Supply className to kind
  def is_a_homogenous_array?(kind)

    flag = true if self.is_a?(Array) && self.length != 0
    self.each do |v|
      flag &= false unless v.kind_of?(kind)
      break unless flag
    end

    return flag
  end
end
