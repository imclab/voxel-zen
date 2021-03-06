
module.exports = (game, opts) -> new ZenPlugin game, opts
module.exports.pluginInfo =
  clientOnly: true

class ZenPlugin
  constructor: (@game, opts) ->
    throw 'voxel-zen requires "kb-bindings" as game.buttons' if not @game.buttons.down?

    @zenMode = false
    @enable()

  enter: () ->
    document.getElementById('logo')?.style?.visibility = 'hidden'
    document.getElementById('stats')?.style?.visibility = 'hidden'
    @game.plugins.disable 'voxel-inventory-hotbar' # TODO: add explicit method to toggle visibility instead of disabling entire plugin?
    @game.plugins.disable 'voxel-voila'
    @getDatgui()?.style?.visibility = 'hidden'
    @zenMode = true

  leave: () ->
    document.getElementById('logo')?.style?.visibility = ''
    document.getElementById('stats')?.style?.visibility = ''
    @game.plugins.enable 'voxel-inventory-hotbar' # TODO: remember state, only re-enable if was enabled first?
    @game.plugins.enable 'voxel-voila'
    @getDatgui()?.style?.visibility = ''
    @zenMode = false

  getDatgui: () ->
    a = document.getElementsByClassName('dg') # TODO: find out how dat.gui handle 'H' hotkey and Close Button, might do more than hiding? (tick listeners)
    return a[0] if a?

  toggle: () ->
    if @zenMode
      @leave()
    else
      @enter()

  enable: () ->
    @game.buttons.down.on 'zen', @down = () =>
      @toggle()

  disable: () ->
    @game.buttons.down.remove 'zen', @down

