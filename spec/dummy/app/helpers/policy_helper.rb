module PolicyHelper
  def can?(symbol, object)
    true
  end

  def can_set?(attribute, object)
    true
  end
end