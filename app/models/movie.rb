class Movie < ActiveRecord::Base
  def self.ratings_avail
    ['G','PG','PG-13','R']
  end
  def self.mapping_data
    select(:rating).map(&:rating).uniq
  end
end