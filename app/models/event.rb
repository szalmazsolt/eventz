class Event < ApplicationRecord

  # ActiveRecord callbacks
  # these are methods that run at certain point in the model object's life cycle
  # available callbacks:
  # before_validation
  # after_validation
  # before_save
  # after_save
  before_save :set_slug

  # the has_many declartion gives us methods on an event object to access its associated registrations
  # to get the registrations for the event
  # event.registrations
  # to create registration for an event
  # event.registration.new()
  has_many :registrations, dependent: :destroy
          # :dependent :destroy makes sure all children registration are destroyed when an event is destroyed
  
  has_many :likes, dependent: :destroy

  # we declare that an event has many likers though the likes association
  # the source option defines what a liker is. it is a user
  has_many :likers, through: :likes, source: :user

  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  # Using ActiveStorage
  # this declaration says there is one main image for an event
  # main_image is a custom name, we can choose it
  has_one_attached :main_image

  # the has_one_attached method basically creates two associations:
  # has_one :main_image_attachment, dependent: :destroy
  # has_one :main_image_blob, through: :main_image_attachment
           

  validates :name, presence: true, uniqueness: true
  validates :location, presence: true
  validates :description, length: {minimum: 20, maximum: 400}
  validates :price, numericality: {greater_than_or_equal_to: 0}
  validates :capacity, numericality: 
                      {greater_than: 0, only_integer: true}

  # Defining our own custom validation with validate and a method name
  validate :acceptable_image
  

  # A scope defines a class method for us dinamically
  # first parameter is the name of the method/scope, the second is the query
  # We can think of a scope as simply a named custom query
  # the query needs to be reevaluated every time the scope is called
  # therefore the second parameter must be a callable object
  # for this, we need to use lambda with curly braces
  # the lamba turn the block into a callable object, also called a Proc object
  # instead of the word 'lambda' we can use an arrow ->
  scope :past, lambda { where("starts_at < ?", Time.now).order("starts_at") }

  scope :upcoming, -> { where("starts_at > ?", Time.now).order("starts_at") }

  # scope for upcoming free events
  scope :free, -> { upcoming.where(price: 0).order("starts_at") }
  # We can also chain scope together, like Event.upcoming.free

  # scope for the past n number of events
  # we pass arguments to a scope, event provide a default value
  scope :recent, ->(n=3) { past.limit(n) }

  # put class method on top
  # class methods work on the whole class and defined by 'self'
  # def self.upcoming
  #   # you do not need to put 'self' in front, because we already used in the method name
  #   # the class is the implicit reciever of the statement below
  #   where("starts_at > ?", Time.now).order("starts_at")
  # end

  # these methods basically just give a name to a query (upcoming, past)
  # this works, but Rails gives us another ways to define custom queries
  # it's called a scope
  # def self.past
  #   where("starts_at < ?", Time.now).order("starts_at")
  # end

  def free?
    price.blank? || price.zero?
  end

  def sold_out?
    (capacity - registrations.size).zero?
  end

  # overriding the default to_param method
  # instead of returning the string representaion of event id, now it returns its name
  def to_param
    # we need to turn the name into a url friendly format by the parameterize method
    # this return a name like "kata-camp"
    # name.parameterize

    # we just return what to set_slug callback returns, the slug
    slug
  end

  private

    # defining a before_save callback
    def set_slug
      # we need to use self when we assign the a model's attribute
      # otherwise slug will just be treated as a local variable, not an attribute
      # we don't need self before reading an attribute (like "name" in this case), only when we are assigning a value to an attribute
      self.slug = name.parameterize
    end

    def acceptable_image
      # first we check if the event has an attached image at all
      # it it does not, we do not run the method
      return unless main_image.attached?

      unless main_image.byte_size <= 1.megabyte
        # if the attached image is larger than 1MB we add to the error collection a custom message for the main_image attribute
        errors.add(:main_image, "is too big")
      end

      acceptable_formats = ["image/jpeg", "image/png"]
      unless acceptable_formats.include?(main_image.content_type)
        errors.add(:main_image, "must be a JPEG or PNG")
      end

    end

end
