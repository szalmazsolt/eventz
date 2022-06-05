module LikesHelper

  def like_or_unlike_button(event, like)
    if like
      # button_to uses to POST method by default, so we need to specify the method option to delete a like %>
      # looking at routes, destroying a like needs both an event id and a likes id, so we pass in both as arguments 
      button_to "★ Unlike", event_like_path(event, like),
                     method: :delete 
    else
      button_to "☆ Like", event_likes_path(event)
    end
  end
end
