require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def home
    session[:number_of_games] = 0
    session[:average_response_time] = 0
  end

  def play
    @grid = generate_grid(8)
    @start_time = Time.now
  end

  def score
    @attempt = params['attempt']
    @end_time = Time.now
    @start_time = params['start_time'].to_time
    @grid = eval(params['grid'])
    @score = run_game(@attempt, @grid, @start_time, @end_time)
    @grid = eval(params['grid'])
    session[:average_response_time] = (session[:average_response_time] * session[:number_of_games] + @score[:time]) / (session[:number_of_games] + 1)
    session[:number_of_games] += 1
    @number_of_games = session[:number_of_games]
    @average_response_time = session[:average_response_time]
  end

  def generate_grid(grid_size)
    grid = []
    grid_size.times { grid << ("A".."Z").to_a.sample }
    grid
  end

  def english_word?(word)
    wagon_dict_api_url = "https://wagon-dictionary.herokuapp.com/"
    parse = JSON.parse(open(wagon_dict_api_url + word).read)
    parse["found"]
  end

  def every_letter_in_grid?(word, grid)
    word.upcase.chars.each do |chr|
      if grid.include?(chr)
        grid.slice!(grid.index(chr))
      else
        return false
      end
    end
    return true
  end

  def run_game(attempt, grid, start_time, end_time)
    # runs the game and return detailed hash of result
    hash_of_results = { time: end_time - start_time }

    if english_word?(attempt) == false
      hash_of_results[:score] = 0
      hash_of_results[:message] = "Your word is not an english word"
    elsif every_letter_in_grid?(attempt, grid) == false
      hash_of_results[:score] = 0
      hash_of_results[:message] = "Letters of your word are not in the grid"
    else
      hash_of_results[:score] = 100 + attempt.size * 3 - hash_of_results[:time]
      hash_of_results[:message] = "Well done"
    end

    hash_of_results
  end
end
