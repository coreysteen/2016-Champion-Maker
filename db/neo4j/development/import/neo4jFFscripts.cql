MATCH (n)
WITH n LIMIT 10000
OPTIONAL MATCH (n)-[r]->()
DELETE n,r;

LOAD CSV WITH HEADERS FROM "file:///auctionsheet.csv"
  AS line
CREATE (:Player {playerID: toInt(line.playerID), name:line.PlayerName, tier: toInt(line.TIER), positionRank: toInt(line.PosRank), snakeRound: toInt(line.sround), stdDev: toInt(line.stddev), estimatedValue: toInt(line.evalue)});

LOAD CSV WITH HEADERS FROM "file:///auctionsheet.csv"
  AS line
MATCH (p:Player {name:line.PlayerName})
MERGE (t:Team {name:line.TEAM})
CREATE (p)-[:PLAYS_FOR]->(t);

LOAD CSV WITH HEADERS FROM "file:///auctionsheet.csv"
  AS line
MATCH (p:Player {name:line.PlayerName})
MERGE (pos:Position {name:line.POSITION})
CREATE (p)-[:PLAYS]->(pos);

CREATE (:Owner {name: "Corey"});
CREATE (:Owner {name: "Kevin"});
CREATE (:Owner {name: "Sager"});
CREATE (:Owner {name: "Belvin"});
CREATE (:Owner {name: "James"});
CREATE (:Owner {name: "Matt"});
CREATE (:Owner {name: "Holt"});
CREATE (:Owner {name: "Nate"});
CREATE (:Owner {name: "Nugent"});
CREATE (:Owner {name: "Jimmy"});
CREATE (:Owner {name: "Mark"});
CREATE (:Owner {name: "Broom"});
