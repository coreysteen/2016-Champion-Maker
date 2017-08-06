class Team 
  include Neo4j::ActiveNode
  property :name, type: String

 has_many :in, :player, type: 'PLAYS_FOR'

 def self.getSortedTeams
	Team.all.sort do |a, b|
        posA = a.name
        posB = b.name
        posA <=> posB
      end  
 end

 def self.getTeamByName(name)
  Team.where(name: name).first
end

end
