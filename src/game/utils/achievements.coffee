
userData = require './userData'
renderer = require '../../core/renderer'

body = $ 'body'

if localStorage.achievementsData?
  achievementsData = JSON.parse localStorage.achievementsData
else
  achievementsData = {}

unlocked = userData.getUnlockedAchievements()

achievements =

  novice:
    title: 'Novice'
    description: 'Complete a level'

  committed:
    title: 'Commited'
    description: 'Complete the game'

  allstars:
    title: 'All Stars'
    description: 'Complete all levels with 3 stars'

  hacker:
    title: 'All Stars'
    description: 'Complete a level with spare shots'

  fryup:
    title: 'Fry-up'
    description: 'Get burned by lasers 10 times'

module.exports = window.a =

  isUnlocked: (id) ->
    return (unlocked.indexOf id) isnt -1

  unlock: (id) ->
    unless @isUnlocked id
      unlocked.push id
      userData.storeUnlockedAchievements unlocked
      @displayAchievement id

  displayAchievement: (id) ->
    achievement = achievements[id]

    ctx =
      id: id
      title: achievement.title
      description: achievement.description

    el = $ renderer.render 'achievement-notification', ctx
    el.css opacity: 0, top: -100
    body.append el

    el.transition opacity: 1, top: 0, 300, =>
      setTimeout ( =>
        el.transition opacity: 0, top: -100, 300, =>
          el.remove()
        ), 2500

  getData: (key) ->
    return achievementsData[key] or null
    
  storeData: (data) ->
    $.extend achievementsData, data
    localStorage.achievementsData = JSON.stringify achievementsData
