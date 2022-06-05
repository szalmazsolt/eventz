module RegistrationsHelper

  def register_or_sold_out(event)
    if event.sold_out?
      # a helper method is just Ruby code, so we can't use html tags
      # instead we use the content_tag helper to generate html
      content_tag(:span, "Sold out", class: "sold-out")
    else
      link_to "Register", new_event_registration_path(event), class: "register"
    end
  end
end
