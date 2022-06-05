module EventsHelper

  def price(event)
    event.free? ? "Free" : number_to_currency(event.price, precision: 2)
  end

  def day_and_time(event)
    event.starts_at.strftime("%B %d, %Y at %I:%M %P")
  end

  def main_image(event)
    # ActiveStorage gives us an attached? method to check if an event has a main image attached to it
    if event.main_image.attached?
      image_tag event.main_image.variant(resize_to_limit: [75, 75])
    else
      image_tag "placeholder"
    end
  end

end
