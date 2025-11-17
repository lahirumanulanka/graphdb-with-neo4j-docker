// Small social network dataset (idempotent)

// Create users
UNWIND [
  {name:'Alice',  city:'Colombo',     joinYear:2022},
  {name:'Bob',    city:'Galle',       joinYear:2021},
  {name:'Carol',  city:'Kandy',       joinYear:2023},
  {name:'Dave',   city:'Jaffna',      joinYear:2020},
  {name:'Eve',    city:'Colombo',     joinYear:2024},
  {name:'Frank',  city:'Negombo',     joinYear:2022},
  {name:'Grace',  city:'Matara',      joinYear:2021},
  {name:'Heidi',  city:'Kandy',       joinYear:2020},
  {name:'Ivan',   city:'Colombo',     joinYear:2023},
  {name:'Judy',   city:'Galle',       joinYear:2022},
  {name:'Mallory',city:'Anuradhapura',joinYear:2021},
  {name:'Niaj',   city:'Colombo',     joinYear:2024},
  {name:'Olivia', city:'Kandy',       joinYear:2022},
  {name:'Peggy',  city:'Galle',       joinYear:2020},
  {name:'Trent',  city:'Colombo',     joinYear:2021}
] AS u
MERGE (x:User {name:u.name})
SET x.city = u.city, x.joinYear = u.joinYear;

// Create follow relationships
UNWIND [
  ['Alice','Bob'],
  ['Bob','Carol'],
  ['Carol','Alice'],
  ['Dave','Alice'],
  ['Eve','Bob'],
  ['Frank','Carol'],
  ['Grace','Dave'],
  ['Heidi','Eve'],
  ['Ivan','Frank'],
  ['Judy','Grace'],
  ['Mallory','Heidi'],
  ['Niaj','Ivan'],
  ['Olivia','Judy'],
  ['Peggy','Mallory'],
  ['Trent','Peggy'],
  // extra cross-links for connectivity
  ['Alice','Eve'],
  ['Bob','Frank'],
  ['Carol','Grace'],
  ['Dave','Bob'],
  ['Eve','Carol'],
  ['Frank','Alice'],
  ['Judy','Alice'],
  ['Ivan','Bob']
] AS pair
MATCH (a:User {name: pair[0]}), (b:User {name: pair[1]})
MERGE (a)-[:FOLLOWS]->(b);
