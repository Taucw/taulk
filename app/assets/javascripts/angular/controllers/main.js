function MainCtrl($scope) {
  $scope.flow = 'this is the flow';
  $scope.chatitems = [
    { from: 'user1', content: 'this is the main chat window'},
    { from: 'user2', content: 'yes it is!'}
  ];
  console.log($scope)
}