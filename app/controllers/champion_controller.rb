class ChampionController < ApplicationController
  def home

    $pickNumber 
  	@players = Player.all 
 	  @undraftedPlayers = Player.getUndraftedPlayers(@players).sort! { |a,b| a.name <=> b.name }
  	@owners = Owner.all.order(:name)
  	@selectedPlayerID = params[:selectedPlayer]

  	if @selectedPlayerID.nil? != true
  		@selectedPlayer = Player.where(playerID: @selectedPlayerID).first
		if (@undraftedPlayers.include?(@selectedPlayer) != true)
  			@selectedPlayer = @undraftedPlayers.first
  		end ##if
  	 else
  	 	@selectedPlayer = @undraftedPlayers.first
  	end ## if

   	@playersTeam = @selectedPlayer.getTeam()
   	@playersPosition = @selectedPlayer.getPosition()

   	@draftedPlayers = Owner.getAllDraftedPlayers().sort! { |a,b| a.pickNumber <=> b.pickNumber }
   
   	if (@draftedPlayers.empty?)
   		$pickNumber = 0
   	else
   		$pickNumber = @draftedPlayers.last.pickNumber
   	end #if



  end ## home

#################################################################################
  def about
    playerName = params[:playerName]
    playerPosition = params[:position]
    playersTeam = params[:team]

    playerID = Player.getLastPlayerID.next


    player = Player.new({name: playerName, playerID: playerID, positionRank: 99, tier: 11, snakeRound: 19, estimatedValue: 1, stdDev: 1 })
    player.save

    team = Team.getTeamByName(playersTeam)
    position = Position.getPositionByName(playerPosition)


    player.create_rel("PLAYS", position)
    player.save

    player.create_rel("PLAYS_FOR",team)
    player.save

    @selectedPlayer = playerID

    redirect_to action: "home", selectedPlayer: playerID

  end ## about
#################################################################################
  def draft
   	@selectedOwner = params[:owner]
  	@draftAmount = params[:draftAmount]
  	@playerID = params[:player]
  	@keeper = params[:keeper]

  	owner = Owner.where(name: @selectedOwner).first
  	player = Player.where(playerID: @playerID).first
  
    if $pickNumber == nil
    	$pickNumber = 1
    else
    	$pickNumber = $pickNumber + 1
    end
  	owner.create_rel("DRAFTED", player, {:draftAmount=>@draftAmount,:keeper=>@keeper,:pickNumber=>$pickNumber})
  	player[:pickNumber] = $pickNumber
  	player.save
  	@selectedPlayer = nil
  	@selectedPlayerID = nil
  	redirect_to action: "home", selectedPlayer: nil
  end ## def draft
##################################################################################
 
def addPlayer

end

end ## end of class
