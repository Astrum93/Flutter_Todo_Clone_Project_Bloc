import 'package:fast_app_base/data/memory/bloc/bloc_status.dart';
import 'package:fast_app_base/data/memory/bloc/todo_bloc_state.dart';
import 'package:fast_app_base/data/memory/todo_status.dart';
import 'package:fast_app_base/data/memory/vo_todo.dart';
import 'package:fast_app_base/screen/dialog/d_confirm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screen/main/write/d_write_todo.dart';

class TodoCubit extends Cubit<TodoBlocState> {
  TodoCubit() : super(const TodoBlocState(BlocStatus.initial, <Todo>[]));

  void addTodo() async {
    final result = await WriteTodoDialog().show();
    if (result != null) {
      /// Bloc의 state 안의 List는 수정 불가. 그러므로 수정 가능하게 변경하여 바뀐 state를 알려주는 방식으로 적용
      final copiedOldTodoList = List.of(state.todoList);
      copiedOldTodoList.add(Todo(
        id: DateTime.now().microsecondsSinceEpoch,
        title: result.text,
        dueDate: result.dateTime,
        createdTime: DateTime.now(),
        status: TodoStatus.incomplete,
      ));
      emitNewList(copiedOldTodoList);
    }
  }

  void changeTodoStatus(Todo todo) async {
    /// Bloc의 state 안의 List는 수정 불가. 그러므로 수정 가능하게 변경하여 바뀐 state를 알려주는 방식으로 적용
    final copiedOldTodoList = List.of(state.todoList);

    /// Todo todo와 copiedOldTodoList의 위치 확인
    final todoIndex =
        copiedOldTodoList.indexWhere((element) => element.id == todo.id);

    /// Todo를 @freezed 한 후
    TodoStatus status = todo.status;
    switch (todo.status) {
      case TodoStatus.incomplete:
        status = TodoStatus.ongoing;
      case TodoStatus.ongoing:
        status = TodoStatus.complete;
      case TodoStatus.complete:
        final result = await ConfirmDialog('정말로 처음 상태로 변경 하시겠어요?').show();
        result?.runIfSuccess((data) {
          status = TodoStatus.incomplete;
        });
        status = TodoStatus.incomplete;
    }

    /// 알아낸 위치정보를 활용하여 todo 수정
    copiedOldTodoList[todoIndex] = todo.copyWith(status: status);
    emitNewList(copiedOldTodoList);
  }

  void editTodo(Todo todo) async {
    final result = await WriteTodoDialog(todoForEdit: todo).show();
    if (result != null) {
      final oldCopiedList = List<Todo>.from(state.todoList);
      oldCopiedList[oldCopiedList.indexOf(todo)] = todo.copyWith(
        title: result.text,
        dueDate: result.dateTime,
        modifyTime: DateTime.now(),
      );
      emitNewList(oldCopiedList);
    }
  }

  void removeTodo(Todo todo) {
    final oldCopiedList = List<Todo>.from(state.todoList);
    oldCopiedList.removeWhere((element) => element.id == todo.id);
    emitNewList(oldCopiedList);
  }

  void emitNewList(List<Todo> oldCopiedList) {
    emit(state.copyWith(todoList: oldCopiedList));
  }
}
