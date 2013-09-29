
###
## Achievements module

Manager for achievements data, displays notifications when an achievement is
unlocked from another module class
###

userData = require './userData'
renderer = require '../../core/renderer'

notificationsWrap = $ '#notifications-wrap'

selectors =
  notification: '.achievement-notification'

conf =
  notificationMargin: 10
  transitionDuration: 300
  notificationPersistance: 2500

# Gets achievements data from localStorage or creates new object
# `achievementsData` is ment to contain persistant stats that other modules use
# to calculate if an achievement has or hasn't been unlocked
if localStorage.achievementsData?
  achievementsData = JSON.parse localStorage.achievementsData
else
  achievementsData = {}

# Get array of ids of unlocked achievements from `userData` module
unlocked = userData.getUnlockedAchievements()

achievements =

  # Logic contained in `GameView`
  novice:
    title: 'Novice'
    description: 'Complete a level'

  champion:
    title: 'Champion'
    description: 'Complete the game'

  master:
    title: 'Master'
    description: 'Complete all levels with 3 stars'

  hacker:
    title: 'All Stars'
    description: 'Complete a level with shots left'

  # Logic contained in `LaserBehaviour`
  fryup:
    title: 'Fry-up'
    description: 'Get burned by lasers 10 times'

module.exports = window.a =

  # Returns true if achievement of given id has been unlocked
  isUnlocked: (id) ->
    return (unlocked.indexOf id) isnt -1

  # Unlock achievement of given id
  unlock: (id) ->
    unless @isUnlocked id
      unlocked.push id
      userData.storeUnlockedAchievements unlocked
      @displayAchievement id

  # Display a notification with the unlocked achievement
  displayAchievement: (id) ->
    achievement = achievements[id]

    ctx =
      id: id
      title: achievement.title
      description: achievement.description

    el = $ renderer.render 'achievement-notification', ctx
    el.css opacity: 0, top: -100
    notificationsWrap.append el

    el.transition opacity: 1, top: 0, conf.transitionDuration, =>
      setTimeout ( =>
        el.transition opacity: 0, top: -100, conf.transitionDuration, =>
          el.remove()
        ), 2500

  # Returns stored `achievementsData` object
  getData: (key) ->
    return achievementsData[key] or null

  # Stores given object keys and values in `achievementsData`
  storeData: (data) ->
    $.extend achievementsData, data
    localStorage.achievementsData = JSON.stringify achievementsData
