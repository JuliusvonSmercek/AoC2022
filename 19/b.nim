import utils, strutils, sequtils

type
  Material = object
    ore, clay, obsidian, geode: int

  BluePrint = object
    oreRobot, clayRobot, obsidianRobot, geodeRobot: Material

proc `+`(a, b: Material): Material = Material(ore: a.ore + b.ore, clay: a.clay + b.clay, obsidian: a.obsidian + b.obsidian, geode: a.geode + b.geode)

proc `-`(a, b: Material): Material = Material(ore: a.ore - b.ore, clay: a.clay - b.clay, obsidian: a.obsidian - b.obsidian, geode: a.geode - b.geode)

proc howMuchFurtherSteps(newResources, newRobot: Material, time: int): (int, Material) =
  result = (1, newResources)
  while result[0] <= time and (result[1].ore < 0 or result[1].clay < 0 or result[1].obsidian < 0 or result[1].geode < 0):
    result = (result[0] + 1, result[1] + newRobot)
  return result

template buyRobot(robotType, robotMax, robotCost, spawnRobo) =
  if robotType < robotMax:
    let (steps, newResources) = howMuchFurtherSteps(resources + robot - robotCost, newRobot, time)
    if steps <= time:
      result = max(result, solve(blueprint, maxRobots, time - steps, newRobot, spawnRobo, newResources))

proc solve(blueprint: BluePrint, maxRobots: Material, time: int, robot = Material(ore: 1), nextGenRobot = Material(), resources = Material()): int =
  if time < 1: return resources.geode
  let newRobot = robot + nextGenRobot

  result = resources.geode + time * (newRobot - nextGenRobot).geode
  buyRobot(newRobot.ore, maxRobots.ore, blueprint.oreRobot, Material(ore: 1))
  buyRobot(newRobot.clay, maxRobots.clay, blueprint.clayRobot, Material(clay: 1))
  buyRobot(newRobot.obsidian, maxRobots.obsidian, blueprint.obsidianRobot, Material(obsidian: 1))
  buyRobot(newRobot.geode, maxRobots.geode, blueprint.geodeRobot, Material(geode: 1))

var result = 1
for line in load().splitLines[0..<3]:
  let ints = line.toInts()
  let blueprint = BluePrint(oreRobot: Material(ore: ints[1]),
                            clayRobot: Material(ore: ints[2]),
                            obsidianRobot: Material(ore: ints[3], clay: ints[4]),
                            geodeRobot: Material(ore: ints[5], obsidian: ints[6]))
  let robots = @[blueprint.oreRobot, bluePrint.clayRobot, blueprint.obsidianRobot, bluePrint.geodeRobot]
  let geodes = blueprint.solve(Material(ore: max robots.mapIt(it.ore), clay: max robots.mapIt(it.clay), obsidian: max robots.mapIt(it.obsidian), geode: high(int)), 32)
  result *= geodes
echo result