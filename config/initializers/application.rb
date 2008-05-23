# Only save the attributes that have changed since the record was loaded.
ActiveRecord::Base.partial_updates = true