import 'package:fast_app_base/data/memory/bloc/bloc_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../vo_todo.dart';

part 'todo_bloc_state.freezed.dart';

@freezed
class TodoBlocState with _$TodoBlocState {
  const factory TodoBlocState(
    BlocStatus status,
    List<Todo> todoList,
  ) = _TodoBlocState;
}
