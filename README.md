# Neo4j with Docker — My Class Notes

This is my simple Neo4j setup for a course task. I run Neo4j in Docker, load a tiny social network, and try a few queries (connections, most connected, shortest path). These are the steps I used on my laptop.

## What’s inside

- `task3-neo4j-graphdb/`
  - `docker/` (compose file and env if I want to use Compose)
  - `cypher/` (dataset seed + queries)
  - `docs/` (notes/results)
  - `screenshots/` (where I put browser screenshots)

## What I needed

- Windows + Docker Desktop

## Start Neo4j (quick way)

I use a single container. If I remove it, the data resets (ok for dev).

```powershell
# pull latest neo4j image
docker pull neo4j:latest

# run neo4j (password must be 8+ chars)
docker run -d \
  --name neo4j-graphdb \
  -p 7474:7474 -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/test1234 \
  neo4j:latest

# open the browser (login: neo4j / test1234)
# http://localhost:7474
```

If ports are busy, I stop any old container first:
 
```powershell
docker stop neo4j-graphdb; docker rm neo4j-graphdb
```

## (Optional) Docker Compose

Compose file: `task3-neo4j-graphdb/docker/docker-compose.yml`

```powershell
cd "c:\\Users\\ASUS\\Documents\\graphdb-with-neo4j-docker\\task3-neo4j-graphdb\\docker"
docker compose up -d
```

I change the password in `docker/neo4j.env` if needed.

## Load my small dataset

I use 15 users and `:FOLLOWS` links. I can reset and re-seed anytime.

```powershell
$container = "neo4j-graphdb"
$pass = "test1234"
$root = "c:\\Users\\ASUS\\Documents\\graphdb-with-neo4j-docker\\task3-neo4j-graphdb"

# copy scripts into the container
docker cp "$root\\cypher\\cleanup.cypher" ${container}:/cleanup.cypher
docker cp "$root\\cypher\\seed.cypher" ${container}:/seed.cypher

# reset then seed
docker exec -i ${container} cypher-shell -u neo4j -p ${pass} -f /cleanup.cypher
docker exec -i ${container} cypher-shell -u neo4j -p ${pass} -f /seed.cypher
```

Quick check:

```powershell
docker exec -i neo4j-graphdb cypher-shell -u neo4j -p test1234 "MATCH (u:User) RETURN count(u) AS users;"
docker exec -i neo4j-graphdb cypher-shell -u neo4j -p test1234 "MATCH (:User)-[r:FOLLOWS]->(:User) RETURN count(r) AS follows;"
```

## Queries I ran

Files live in `task3-neo4j-graphdb/cypher/queries`.

### Connected users (within 3 hops)

```powershell
# Browser: :param name => 'Alice';
$container = "neo4j-graphdb"; $pass = "test1234"
docker cp "$root\\cypher\\queries\\q1_connected_users.cypher" ${container}:/q1.cypher

# run with a param (cypher-shell syntax)
docker exec -i ${container} cypher-shell -u neo4j -p ${pass} -f /q1.cypher --param "name => 'Alice'"
```

### Most connected users (by total degree)

```powershell
$container = "neo4j-graphdb"; $pass = "test1234"
docker cp "$root\\cypher\\queries\\q2_most_connected.cypher" ${container}:/q2.cypher

docker exec -i ${container} cypher-shell -u neo4j -p ${pass} -f /q2.cypher
```

### Shortest path between two users

```powershell
# Browser: :param from => 'Alice'; :param to => 'Mallory';
$container = "neo4j-graphdb"; $pass = "test1234"
docker cp "$root\\cypher\\queries\\q3_shortest_path.cypher" ${container}:/q3.cypher

docker exec -i ${container} cypher-shell -u neo4j -p ${pass} -f /q3.cypher --param "from => 'Alice'" --param "to => 'Mallory'"
```

## Screenshots I plan to include

I save these in `task3-neo4j-graphdb/screenshots/`:

- `browser_create_data.png` (after seeding, show counts)
- `query1_output.png` (connected users)
- `query2_output.png` (most connected)
- `query3_output.png` (shortest path)

I also keep the text outputs (`*.txt`) in the same folder for easy copy/paste.

## If something breaks

- Password must be ≥ 8 chars (Neo4j rule).
- If the shell says connection refused, wait a few seconds and try again.
- Port in use? Stop and remove old containers.
- Params in cypher-shell: `--param "name => 'Alice'"`.

## Clean up

```powershell
# stop and remove the quick-run container
docker stop neo4j-graphdb
docker rm neo4j-graphdb

# if using compose
cd "c:\\Users\\ASUS\\Documents\\graphdb-with-neo4j-docker\\task3-neo4j-graphdb\\docker"
docker compose down
```