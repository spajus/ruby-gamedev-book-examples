class GameObject

  def mark_for_removal
    @removable = true
  end


  def removable?
    @removable
  end
end
