# Makes,renders and changes the board
class Board
  def initialize
    @walls = ['||', '|', '|', '|| ']
    @cell_index = 1
    @row_value = ''
    @rows = {
    header:"_____________________",
    row1:"",
    row2:"",
    row3:"",
    footer:"---------------------"
    }
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
    @player_one = Player.new("Player 1", :X, @board)
    @player_two = Player.new("Player 2", :O, @board)
    @player_one.ask_for_coordinate
  end

  # Play against computer
  def one_player_play
    @player_one = Player.new("Player 1", :X, @board)
  end
end
  
class Player
  attr_accessor :name, :piece

  def initialize(name, piece,board)
    @name = name
    @piece = piece
    @board = board
    puts "#{@name} is #{@piece}"
  end

  def ask_for_coordinate
    puts '---------------------'
    puts "#{@name}'s move: "
    @move = gets.chomp
  end
end

game = Game.new