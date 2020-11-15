
# Includes small manipulations that can be applied to a hash of the form { card_name => card_count }
class CollatedCardList
  attr_accessor :card_hash

  # Example card_hash: { "Counterspell" => 3, "Possibility Storm" => 2 }
  def initialize(card_hash)
    @card_hash = card_hash
  end

  #### Chainable Operations ####

  def sort_by_card_count_desc
    CollatedCardList.new(card_hash.sort_by { |_, v| -v }.to_h)
  end

  def cap_card_counts_at(number)
    CollatedCardList.new(
      card_hash.transform_values { |card_count| [card_count, number].min }
    )
  end

  #### Non-Chainable Operations ####

  def total_card_count
    card_hash.values.reduce(:+)
  end

  def unique_card_count
    card_hash.size
  end

  def pretty_print
    card_hash.map do |card_name, card_count|
      "#{card_count} #{card_name}\n"
    end.join
  end
end