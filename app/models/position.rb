class Position 
  include Neo4j::ActiveNode
  property :name, type: String


has_many :in, :player, type: 'PLAYS'



################################################################################
  	def getPositonSortValue
  		case
  			when self.name == "QB"
    			return 8
  			when self.name == "WR"
    			return 7
  			when self.name == "RB"
    			return 6
  			when self.name == "TE"
    			return 5
  			when self.name == "K"
    			return 4
  			when self.name == "DL"
    			return 3
  			when self.name == "LB"
    			return 2
  			else
    			return 1
  			end 
  	end	#getPositionSortValue

def self.getPositionByName(name)
  Position.where(name: name).first
end

def self.getSortedPositions
  Position.all.sort do |a, b|
        posA = a.getPositonSortValue
        posB = b.getPositonSortValue
        posB <=> posA
      end  

end

def getPositionBGColor
    position = self.name
      bgcolor = ""
      if position == "QB"
        bgcolor = "#FAC203"
      elsif position == "WR"
          bgcolor = "#E6F927"
      elsif position == "RB"
          bgcolor = "#77F927"
      elsif position == "TE"
          bgcolor = "#27BDF9"
      elsif position == "K"
          bgcolor = "#F627F9"
      else
        bgcolor = "#FA2B2B"
      end ## end if
      return bgcolor
  end ## getPositionBGColor


end
