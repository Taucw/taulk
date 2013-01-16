describe 'MainCtrl', ->
  scope = ''
  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new
    ctrl = $controller MainCtrl, $scope: scope

  it 'assigns something to the flow', ->
    expect(scope.flow).toEqual 'this is the flow'