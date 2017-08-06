class Drafted
  include Neo4j::ActiveRel
  before_save :do_this

  from_class :Owner
  to_class   :Player
  type 'DRAFTED'

  property :keeper, type: String
  property :draftAmount, type: Integer
  property :pickNumber

  def do_this
    #a callback
  end
end