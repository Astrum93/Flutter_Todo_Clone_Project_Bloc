import '../vo_todo.dart';

/// sealed는 봉인과 같다. 반드시 상속 받은 자식 class를 전부 사용해야 함
/// event를 빼먹지 않고 사용할 수 있음
// sealed class TodoEvent {}

abstract class TodoEvent {}

class TodoAddEvent extends TodoEvent {}

class TodoStatusUpdateEvent extends TodoEvent {
  final Todo updatedTodo;

  TodoStatusUpdateEvent(this.updatedTodo);
}

class TodoContentUpdateEvent extends TodoEvent {
  final Todo updatedTodo;

  TodoContentUpdateEvent(this.updatedTodo);
}

class TodoRemovedEvent extends TodoEvent {
  final Todo removedTodo;

  TodoRemovedEvent(this.removedTodo);
}
