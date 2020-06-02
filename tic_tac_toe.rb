# Makes,renders,changes and checks the board
class Board
  attr_accessor :rows
  def initialize
    @walls = ['||', '|', '|', '|| ']
    @cell_index = 1
    @row_value = ''
    @rows = { header:"_____________________",
              row1:"",
              row2:"",
              row3:"",
              footer:"---------------------" }
    make_board
    render_board
  end

  def make_board
    for row in 1...4
      @walls.each do |wall|
        @row_value += wall
        if wall == @walls.last
          @rows["row#{row}".to_sym] = @row_value
          @row_value = ''
          next
        end
        @row_value += "  #{@cell_index}  "
        @cell_index += 1
      end
    end
  end

  def render_board
    @rows.each_value do |row|
      puts row
      puts '---------------------'
    end
  end

  def find_n_replace_coord(coord,piece)

    for row in 1...4
      if rows["row#{row}".to_sym].include?(coord)
        row_content = rows["row#{row}".to_sym]
        row_content[coord] = piece.to_s
        rows["row#{row}".to_sym] = row_content
      end
    end
  end

  # Remove borders from the rows hash 
  # return an 2D array of only the specifed buttons and empty strings 
  def rows_strip(button)
    stripped_rows = [[][][]]
    @rows.each_value do |row_str|
      if row_str.exclude?(button.to_s)
        next
      end
      # "X  "
      row_str = row_str.delete('| ').gsub(/[^"#{button}"]/, ' ')
    end
  end
  
  def winning_combination?(button)
    if winning_diagonal?(button) ||
       winning_row?(button) ||
       winning_column?(button)
      true
    end
  end

  def winning_diagonal?(button)
    WIN = [['X', '', '']
           ['', 'X', '']
           ['', '', 'X']]
    current_board = rows_strip(button)

  end
  
   def winning_row?(button)
    
  end

   def winning_column?(button)
    
  end
end

# Manages the flow of the game
class Game

  def initialize
    @banner = File.read("banner.txt")
    puts @banner
    puts 'Choose gamemode:'
    puts '1 Player(1)'
    puts '2 Players(2)'
    while true
      @PLAYER_COUNT = gets.chomp
      begin
        if Integer(@PLAYER_COUNT) == 1 || Integer(@PLAYER_COUNT) == 2
          start_game(@PLAYER_COUNT)
          break
        else
          puts 'Invalid input. Choose 1 or 2.'
        end
      rescue ArgumentError, TypeError
        puts 'Invalid input. Choose 1 or 2.'
      end
    end
  end

  def start_game(player_count)
    @board = Board.new
    player_count == "2" ? two_players_play : one_player_play
  end

  def two_players_play
    @player_one = Player.new('Player 1', :X, @board)
    @player_two = Player.new('Player 2', :O, @board)
    @current_player = @player_one
    loop do
      @board.render_board
      @current_player.get_coordinate
      switch_players
    end
  end

  # Play against computer
  def one_player_play
    @player_one = Player.new('Player 1', :X, @board)
  end

  def switch_players
    if @current_player == @player_one
      @current_player = @player_two
    else
      @current_player = @player_one
    end
  end

  def check_game_over
    check_victory || check_draw
  end

  def check_victory
    @board.winning_combination?(@current_player.piece)
  end
end

# Manages players and player input
class Player
  @@made_moves = []
  attr_accessor :name, :piece

  def initialize(name, piece,board)
    @name = name
    @piece = piece
    @board = board
    puts "#{@name} is #{@piece}"
  end

  # Ask for users input
  def ask_for_coordinate
    puts '---------------------'
    puts "#{@name}'s move: "
    @move = gets.chomp
  end

  # Verify and add to the board
  def get_coordinate
    loop do
      coord = ask_for_coordinate
      if verify_coord(coord)
        @board.find_n_replace_coord(coord, @piece)
        @@made_moves << coord
        break
      end
    end
  end

  def verify_coord(coord)
    begin
      coord = Integer(coord)

      if @@made_moves.include?(coord)
        puts 'Already occupied!'
      elsif coord.between?(1, 9)
        true
        @@made_moves << coord
      else
        puts 'Choose a coordinate from the board between 1 and 9'
      end
    rescue ArgumentError, TypeError
      puts 'Choose a coordinate from the board between 1 and 9'
    end
  end
end

game = Game.new 