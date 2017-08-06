class Owner 
  include Neo4j::ActiveNode

  property :name, type: String

  has_many :out, :player, type: :DRAFTED
#################################################################################
  	def getRemainingBudget
  		sumCosts = 0
  		draftedPlayers = self.rels(dir: :outgoing, type: "DRAFTED")
  		draftedPlayers.each do |draftInfo| 
  		 	sumCosts = sumCosts + draftInfo[:draftAmount].to_i  		 
		end ## loop

		return 200 - sumCosts
  	end #getRemainingBudget
#################################################################################
  	def getRemainingRosterSpots
  		return 18 - getNumberPlayersDrafted 
  	end #getRemainingRosterSpots
#################################################################################
  	def getNumberPlayersDrafted
  		return draftedPlayers = self.rels(dir: :outgoing, type: "DRAFTED").count
  	end #getNumberPlayersDrafted
#################################################################################
  	def getMaxBid
  		return getRemainingBudget - (getRemainingRosterSpots - 1)
  	end #getMaxBid
#################################################################################
  	def getMyPlayers
  		return self.nodes(dir: :outgoing, type: "DRAFTED") 
  	end	#getMyPlayers
 
  	
################################################################################
  	def getMyPlayersSortedByPosition
  		return self.nodes(dir: :outgoing, type: "DRAFTED").sort do |a, b|
  			posA = a.getPosition.getPositonSortValue
  			posB = b.getPosition.getPositonSortValue
  			posB <=> posA
  		end  
  	end	#getMyPlayers
#################################################################################
 	def getPlayersAtPosition(thePosition)
 		myPlayers = Array.new
 		if thePosition == nil
 			return myPlayers
 		end
 		owner = Owner.where(name: self.name)
  		owner.player.each do |thePlayer| 
  		 	if thePlayer.getPosition.name == thePosition.name
  		 		myPlayers.push(thePlayer)
  		 	end  		 
		end ## loop

  		return myPlayers
 	end #getPlayersAtPosition
#################################################################################
 	def self.getAllDraftedPlayers
		draftedPlayers = Array.new
  		self.player.each do |thePlayer| 
  			if thePlayer.owner != nil      		
       			draftedPlayers.push(thePlayer)	
  			end  		 
		end ## loop
  		return draftedPlayers
 	end #getDraftedPlayers
#################################################################################
 	def getAveragePerOpenRosterSpot
 		(getRemainingBudget.to_f/ getRemainingRosterSpots.to_f).round
 	end #getAveragePerOpenRosterSpot
#################################################################################
    def self.getSortedOwners
    	Owner.all.order(:name)
    end #getSortedOwners
#################################################################################
	def self.getDraftedPlayersByPosition(position,draftedPlayers)
		## get all the drafted players by the given position, and order by pick #
		positionPlayers = Array.new
  		draftedPlayers.each do |thePlayer| 
  			if thePlayer.owner != nil      	
  				if thePlayer.getPosition.name == position.name	
  					
       				positionPlayers.push(thePlayer)	
       			end
  			end  		 
		end ## loop
  		return positionPlayers.sort! { |a,b| a.pickNumber <=> b.pickNumber }
	end #getDraftedPlayersByPosition

#################################################################################
	def self.getDraftedPlayersByPositionTier(position, tier, draftedPlayers)
		## get all the drafted players by the given position, and order by pick #
		positionPlayers = Array.new
  		draftedPlayers.each do |thePlayer| 
  			if thePlayer.owner != nil      	
  				if thePlayer.getPosition.name == position.name && thePlayer.tier == tier
       				positionPlayers.push(thePlayer)	
       			end
  			end  		 
		end ## loop

  		return positionPlayers.sort! { |a,b| a.pickNumber <=> b.pickNumber }
	end #getDraftedPlayersByPosition

#################################################################################
def self.getDraftedPlayersByADP(adp, draftedPlayers)
		## get all the drafted players by the given position, and order by pick #
		positionPlayers = Array.new
  		draftedPlayers.each do |thePlayer| 
  			if thePlayer.owner != nil      	
  				if thePlayer.snakeRound == adp
       				positionPlayers.push(thePlayer)	
       			end
  			end  		 
		end ## loop

  		return positionPlayers.sort! { |a,b| a.pickNumber <=> b.pickNumber }
	end #getDraftedPlayersByPosition

#################################################################################
	def getDraftedAtPosition(position)
		## get all the drafted players by the given position, and order by pick #
		positionPlayers = getPlayersAtPosition(position)
		totalPaid = 0
  		positionPlayers.each do |thePlayer| 
  			draftInfo = thePlayer.rel(dir: :incoming, type: "DRAFTED")
  			totalPaid = totalPaid + draftInfo[:draftAmount].to_i
		end ## loop
  		
  		return positionPlayers.size.to_s + "/$" + totalPaid.to_s
	end #getDraftedPlayersByPosition

end

