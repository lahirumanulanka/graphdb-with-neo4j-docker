# Query Results

This file captures outputs for the three sample insights. For graded submissions, capture Neo4j Browser screenshots and save them under `screenshots/` as PNGs with the names below.

## Data Created
- See `screenshots/browser_create_data.txt` for counts.
- Suggested Browser check:
  - `MATCH (u:User) RETURN count(u) AS users;`
  - `MATCH (:User)-[r:FOLLOWS]->(:User) RETURN count(r) AS follows;`

## Query 1 — Connected Users (within 3 hops)
- File: `cypher/queries/q1_connected_users.cypher`
- Browser params: `:param name => 'Alice';`
- Output (text): `screenshots/query1_output.txt`
- Screenshot: `screenshots/query1_output.png`

## Query 2 — Most Connected Users (by degree)
- File: `cypher/queries/q2_most_connected.cypher`
- Output (text): `screenshots/query2_output.txt`
- Screenshot: `screenshots/query2_output.png`

## Query 3 — Shortest Path
- File: `cypher/queries/q3_shortest_path.cypher`
- Browser params: `:param from => 'Alice'; :param to => 'Mallory';`
- Output (text): `screenshots/query3_output.txt`
- Screenshot: `screenshots/query3_output.png`

