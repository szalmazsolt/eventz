class MakeRegistrationsAJoinTable < ActiveRecord::Migration[6.1]
  def change
    # we should specify the type of the fields we want to remove
    # this way, if we decide to rollback the changes, Rails will know what type name and email should be
    remove_column :registrations, :name, :string
    remove_column :registrations, :email, :string
    add_column :registrations, :user_id, :integer

    # we can use regular Ruby code in migrations
    Registration.delete_all
  end
end
