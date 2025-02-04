# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../featured_ids/featured_ids'

class FeaturedIdsTest < Minitest::Test
  def setup
    @source_ids = (1..100).to_a
    @featured_ids = []
    @sample_size = 10
    @max_featured_times = 3
  end

  def test_select_random
    featured_ids = []
    30.times do
      select_random(@source_ids, featured_ids, @sample_size)
    end

    counts = Hash.new(0)
    featured_ids.each { |id| counts[id] += 1 }

    counts.each do |id, count|
      assert count <= @max_featured_times,
             "ID #{id} was featured #{count} times, which exceeds the limit of #{@max_featured_times}"
    end
  end

  def test_select_random_with_empty_source_ids
    featured_ids = []
    select_random([], featured_ids, @sample_size)
    assert_equal [], featured_ids
  end
end
