
class Deck

  attr_accessor(:staples, :non_staples)

  def initialize(cards_hash)
    @complete_list = cards_hash
    @staples, @non_staples = staples_and_not_staples
  end

  private

  attr_accessor(:complete_list)

  def staples_and_not_staples
    complete_list.partition do |card_name, _|
      $STAPLE_LIST.include?(card_name)
    end.map(&:to_h)
  end
end
