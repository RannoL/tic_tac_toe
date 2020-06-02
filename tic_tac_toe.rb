#Makes,renders and changes the board
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

#Manages the flow of the game
class Game

  def initialize
    @banner = File.read("banner.txt")
    puts @banner
    puts 'Choose gamemode:'
    puts '1 Player(1)'
    puts '2 Players(2)'
    while true
      @player_count = gets.chomp
      begin
        if Integer(@player_count) == 1 || Integer(@player_count) == 1
          break
        else
          puts 'Invalid input. Choose 1 or 2.'
        end
 
      rescue ArgumentError, TypeError
        puts 'Invalid input. Choose 1 or 2.'
      end
    end
  end
end
  

game = Game.new