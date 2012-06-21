module ApplicationHelper

  # Returns title on a case by case basis
  def full_title(page_title)
    base_title = "Talisman"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
