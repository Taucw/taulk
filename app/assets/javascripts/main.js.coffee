# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('body').layout
    closable: false,
    resizable: true,
    livePaneResizing: true,
    slidable: true,
    applyDemoStyles: true,
    stateManagement__enabled:	true
    north__size:		"auto",
    north__initClosed:	false,
    north__initHidden:	false,
    north__resizable: false,
    north__slidable: false,
    north__closable: true
