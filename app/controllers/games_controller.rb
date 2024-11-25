require "open-uri"
require "json"

class GamesController < ApplicationController

  def new
    @letters = []
  10.times do
    @letters << ('a'..'z').to_a.sample
  end
    end

  def score
    @word = params[:answer]
    @letters = params[:letters].split # La grille est envoyée sous forme de chaîne, donc on la transforme en tableau de lettres.
    @grid_valid = valid_in_grid?(@word, @letters) # Vérifie si le mot peut être formé avec la grille
    @english_valid = valid_english_word?(@word) # Vérifie si le mot est valide en anglais via l'API

    # Trois scénarios possibles
    if !@grid_valid
      @message = "Le mot ne peut pas être créé à partir de la grille."
    elsif !@english_valid
      @message = "Le mot est dans la grille mais ce n'est pas un mot anglais valide."
    else
      @message = "Bravo ! #{@word} est un mot valide."
    end
  end

  private

  # Vérifie si le mot peut être formé à partir de la grille
  def valid_in_grid?(word, letters)
    word.chars.all? { |char| word.count(char) <= letters.count(char) }
  end

  # Vérifie si le mot est valide en anglais en appelant l'API
  def valid_english_word?(word)
    url = "https://dictionary.lewagon.com/#{word.downcase}"
    begin
      response = URI.open(url).read
      json = JSON.parse(response)
      json["found"] # Retourne true ou false selon si le mot est trouvé dans le dictionnaire
    end
  end
end
