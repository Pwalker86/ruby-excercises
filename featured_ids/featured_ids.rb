# frozen_string_literal: true

# Problem:
#   Given a list of source ids, select a random sample of (n) ids to feature each day.
#   The same id should not be featured more than (m) times in a 30-day period.

SAMPLE_SIZE = 3
FEATURED_LIMIT = 3

source_ids = Array.new(150) { |i| i + 1 }
featured_ids = []

def select_random(source_ids, featured_ids, sample_size = SAMPLE_SIZE)
  # Initialize a hash to keep track of counts
  id_counts = Hash.new(0)
  featured_ids.each { |id| id_counts[id] += 1 }

  # Select random ids
  sample_size.times do
    filtered_ids = source_ids.filter { |id| id_counts[id] < FEATURED_LIMIT }
    selected_id = filtered_ids.sample
    featured_ids << selected_id
    id_counts[selected_id] += 1
  end
  featured_ids.compact!
end

30.times do
  select_random(source_ids, featured_ids)
  break if source_ids.empty?
end

# puts "Featured IDs after 30 days: #{featured_ids.tally}"
