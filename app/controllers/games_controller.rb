require 'open-uri'

class GamesController < ApplicationController
VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    attempt = params[:word]
    letters = params[:letters].split(' ')
    @result = run_game(attempt, letters)
  end

  def run_game(attempt, letters)
    result = { score: 0, message: '' }
    if !attempt_is_english_word(attempt)
      result[:message] = 'not an english word'
    elsif !letters_in_grid(attempt, letters)
      result[:message] = 'not in the grid'
    else
      result[:message] = 'well done'
      result[:score] = attempt.size * 10
    end
    return result
  end

  def letters_in_grid(attempt, letters)
    check_array = []
    split_attempt = attempt.upcase.split('')
    split_attempt.map do |letter|
      if letters.include? letter
        check_array << letter
        letters.delete_at(letters.index(letter))
      end
    end
    check_array.size == split_attempt.size
  end

  def attempt_is_english_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    url_text = open(url).read
    url_hash = JSON.parse(url_text)
    url_hash['found']
  end
end
