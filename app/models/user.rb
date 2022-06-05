class User < ApplicationRecord

  has_many :registrations, dependent: :destroy

  has_many :likes, dependent: :destroy

  has_many :liked_events, through: :likes, source: :event

  # when generating the user resource with password:digest, it will give us the has_secure_password, that generate some convenience methods and validations for storing password in a safe way
  # but we need an additional Ruby gem for this to work, bcrypt
  # has_secure_password will add a password virtual attribute to the user. If we write to the user's password attribute (user.password = "secret"), it will hash the password and store it under user.password_digest
  # it will also add a password_confirmation attribute and validation if the password and password_confirmations match

  # the password and password_confirmation are virtual attributes. They do not have a corresponding column in the database
  # when we assign to the password, like u.password = "secret"
  # the has_secure_password runs a method, the password= method
  # this method hashes the plain text password and saves the plain password to an instance variable
  # def password=("secret")
    # self.password_digest = "hashed value"
    # @password = "secret"
  # end
  # when we set the password_confirmation attribute has_secure_password runs the password_confirmation= method. It simply assigns the plain password_confirmation value to an instance variable
  # def password_confirmation=("secret")
    # @password_confirmation = "secret"
  # end
  # the the built-in validation check if the @password and @password_confirmation intance variable match
  has_secure_password

  validates :name, presence: true
  validates :email, format: { with: /\S+@\S+/, message: "must be a valid email address"},
            # before saving a user to the db, uniqueness checks if the email already exists in the db. By default it is case sensitive
            uniqueness: { case_sensitive: false }
end
