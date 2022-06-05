class Registration < ApplicationRecord

  # belongs_to in the background creates methods for accessing events from a registration or assigning an event to a registration
  # it add an event method to a registration object to set an event
  # registration.event = eventObject
  # to get events for registration
  # registration.event
  belongs_to :event

  belongs_to :user

  HOW_HEARD_OPTIONS = [
    "Newsletter",
    "Blog",
    "Twitter",
    "Web Search",
    "Friend/Coworker",
    "Other"
  ]
  validates :how_heard, inclusion: { in: HOW_HEARD_OPTIONS }
end
