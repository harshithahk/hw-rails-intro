class Movie < ActiveRecord::Base
  def self.ratings_avail
    ['G','PG','PG-13','R']
  end
end