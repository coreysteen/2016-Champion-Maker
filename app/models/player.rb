class Player 
  include Neo4j::ActiveNode

  property :name, type: String
  property :playerID, type: Integer
  property :positionRank, type: Integer
  property :tier,	type: Integer
  property :snakeRound, type: Integer
  property :estimatedValue, type: Integer
  property :stdDev, type: Integer
  property :pickNumber, type: Integer

  has_one :out, :team, type: :PLAYS_FOR
  has_one :out, :position, type: :PLAYS
  has_one :in, :owner, type: :DRAFTED

#################################################################################
  	def getTeam
   		return self.node(dir: :outgoing, type: :PLAYS_FOR) 
  	end #getTeam
##################################################################################################################################################################
  	def self.getLastPlayerID
   		players = Player.all
   		players = players.sort do |a,b| a.playerID <=> b.playerID end
 
   		lastID = players.last.playerID
   		return lastID
  	end #getTeam
#################################################################################
	 def getPosition    
  		return self.node(dir: :outgoing, type: :PLAYS)    
 	end #getPosition
################################################################################
  ## Return array of all currently undrafted players
   	def self.getUndraftedPlayers(players)
  		undraftedPlayers = Array.new
  		players.each do |player|   		
      		if player.rels(dir: :incoming, type: "DRAFTED").empty?
      			undraftedPlayers.push(player)	   
			end ## if
		end ## loop
  		return undraftedPlayers
  	end ## def getUndraftedPlayers
##################################################################################
	def getDraftAmount
		draftedInfo = self.rel(dir: :incoming, type: "DRAFTED")
		draftedInfo[:draftAmount].to_i
	end #getDraftAmount
##################################################################################
	def isKeeper
		draftedInfo = self.rel(dir: :incoming, type: "DRAFTED")
		draftedInfo[:keeper].to_s
	end #isKeeper

#################################################################################
	def getOwner
		self.node(dir: :incoming, type: "DRAFTED")
	end #getOwner
#################################################################################
	def self.getOverallPercentAverage(players)
		##Loop over players drafted
		percentSum = 0.0
		numDraftedPlayers = 0.0
		players.each do |player|
  			if player.getOwner != nil
      			##Get average of percent o/u of expected value
      			exValue = player.estimatedValue.to_f
      			#draftedInfo = player.rels(dir: :incoming, type: "DRAFTED").first
      			actCost = player.getDraftAmount.to_f #draftedInfo[:draftAmount].to_f
				percentDiff = actCost / exValue

				##Sum averages
				percentSum = percentSum + percentDiff
				numDraftedPlayers = numDraftedPlayers + 1
			end ## if
		end ## loop
	
		##return average overall percent o/u
		return percentSum / numDraftedPlayers
	end #getOverallPercentAverage

#################################################################################

	def getExpectedRange

		sd = self.stdDev
		lowValue = (estimatedValue.to_i - stdDev.to_i).to_s
		highValue = (estimatedValue.to_i + stdDev.to_i).to_s
		return "$" + lowValue + " - [$" + estimatedValue.to_s + "] - $" + highValue

	end #getExpectedRange
#################################################################################

	def getLowRange

		sd = self.stdDev
		lowValue = (estimatedValue.to_i - stdDev.to_i).to_s
		
		return "Lower than $" + lowValue 

	end #getExpectedRange
#################################################################################
def getHighRange

		sd = self.stdDev
		highValue = (estimatedValue.to_i + stdDev.to_i).to_s
		return "Greater than $" + highValue

	end #getExpectedRange
#################################################################################

	def getPositionBGColor
		position = self.position.name
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
#################################################################################
def self.calculatePercentageVariance(players)
		##Loop over players drafted
		percentSum = 0.0
		numDraftedPlayers = 0.0
		percentArray = Array.new
		puts players.inspect
		players.each do |player|
  			if player.isKeeper != "yes"
      			##Get average of percent o/u of expected value
      			exValue = player.estimatedValue.to_f
      			
      			actCost = player.getDraftAmount.to_f 
				percentDiff = actCost / exValue
				percentArray.push(percentDiff)	
			end		
		end ## loop
		stats = DescriptiveStatistics::Stats.new(percentArray)
		return stats.mean
end #getPercentageVariance
#################################################################################

#################################################################################
def getUpdatedEstimate(percentVariance)
	return estimatedValue * percentVariance
end # getUpdatedEstimate

#################################################################################
def self.getPercentageVariance(mode,trending,draftedPlayers,position, tier, adp)
	percentVariance = 0
	
	
	if mode == "overall"
		if trending != nil
			percentVariance = calculatePercentageVariance(draftedPlayers.last(3))
		else
			percentVariance =  calculatePercentageVariance(draftedPlayers)
		end ## if trending
				
	elsif mode == "position"
		if trending != nil
			percentVariance =  calculatePercentageVariance(Owner.getDraftedPlayersByPosition(position,draftedPlayers).last(3))
		else
			percentVariance =  calculatePercentageVariance(Owner.getDraftedPlayersByPosition(position,draftedPlayers))
		end ## if trending

	elsif mode == "posTier"
		if trending != nil
			percentVariance =  calculatePercentageVariance(Owner.getDraftedPlayersByPositionTier(position, tier, draftedPlayers).last(3))
		else
			percentVariance =  calculatePercentageVariance(Owner.getDraftedPlayersByPositionTier(position, tier, draftedPlayers))
		end ## if trending

	else ## mode == "ADP"
		if trending != nil
			percentVariance =  calculatePercentageVariance(Owner.getDraftedPlayersByADP(adp,draftedPlayers).last(3))
		else
			percentVariance =  calculatePercentageVariance(Owner.getDraftedPlayersByADP(adp,draftedPlayers))
		end ## if trending
	end # if mode..
	if percentVariance == nil
		return nil
	end
	return percentVariance.round(2)
			
end #getPercentageVariance

end## end Class
