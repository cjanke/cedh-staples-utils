require './deck.rb'

# Sifat would like sorting by CMC but that would require more work
# TODO: too much shit in this main file, should move to decks processor or something else
class Main
  STAPLE_LIST_FILE_NAME = 'staples.txt'

  def initialize
    $STAPLE_LIST = load_file(STAPLE_LIST_FILE_NAME)

    deck_name_list = Dir['./decks_to_analyze/*'].select{ |f| File.file? f }

    deck_list = deck_name_list.map do |deck_name|
      Deck.new(load_file(deck_name))
    end
    
    collated_staples_list = merge_decklist_card_counts(deck_list.map {|deck| deck.staples})
    collated_staples_sorted_by_count = collated_staples_list.sort_by { |_, v| -v }.to_h

    collated_non_staples_list = merge_decklist_card_counts(deck_list.map {|deck| deck.non_staples})
    collated_non_staples_sorted_by_count = collated_non_staples_list.sort_by { |_, v| -v }.to_h
    
    staples_count = collated_staples_list.values.reduce(:+)
    non_staples_count = collated_non_staples_list.values.reduce(:+)
    
    puts "STAPLES: #{staples_count}\n"
    puts pretty_print(collated_staples_sorted_by_count)
    puts "\n"
    puts "NON_STAPLES: #{non_staples_count}\n"
    puts pretty_print(collated_non_staples_sorted_by_count)
  end

  def load_file(filename)
    number_card_title_lines = (File.readlines(filename).map {|str| str.chomp}).reject(&:empty?)
    card_hash(number_card_title_lines)
  end

  def card_hash(file_line_array)
    cards = {}

    file_line_array.each do |number_and_card_title|
      # TODO named groups would be nicer
      # This handles random shit like 
      #   'sb: 1 Sidisi' => '1 Sidisi'
      #   'SIDEBOARD:' => ignored
      parsed_line = /(\d+)\s(\D*)$/.match(number_and_card_title)
      next if parsed_line.nil?
      cards[parsed_line[2]] = parsed_line[1].to_i
    end

    cards
  end

  def merge_decklist_card_counts(deck_list)
    deck_list.reduce do |acc, deck_staples|
      acc.merge(deck_staples) { |card_name, deck1_count, deck2_count| deck1_count + deck2_count }
    end
  end

  def pretty_print(card_hash)
    card_hash.map do |card_name, card_count|
      "#{card_count} #{card_name}\n"
    end
  end
end

Main.new
