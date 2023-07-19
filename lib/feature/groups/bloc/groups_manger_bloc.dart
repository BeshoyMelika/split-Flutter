import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split/feature/groups/data/models/group_item_data.dart';
import 'package:split/feature/groups/data/repositories/groups_data_parent_repo.dart';

part 'groups_manger_event.dart';
part 'groups_manger_state.dart';

class GroupsMangerBloc extends Bloc<GroupsMangerEvent, GroupsMangerState> {
  final GroupsDataParentRepo groupsDataParentRepo;
  List<GroupItemDate> allGroupsList = [];
  List<GroupItemDate> pinnedGroupsList = [];
  GroupsMangerBloc(this.groupsDataParentRepo)
      : super(GroupsMangerInitialState()) {
    ///this for pin or unPin group
    on<PinGroupSwitcherEvent>(_onPinItemSwitcherEvent);
    // this to get all groups data
    on<GetGroupsDataEvent>(_onGetGroupsData);
    //
    on<CheckIsGroupPinnedOrNotEvent>(_onCheckGroupPinnedOrNotEvent);
  }
//
  void _onGetGroupsData(
    GetGroupsDataEvent event,
    Emitter<GroupsMangerState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    emit(AllGroupsListLoadingState());
    allGroupsList = groupsDataParentRepo.allGroupsList;
    pinnedGroupsList = groupsDataParentRepo.pinnedGroupsList;
    try {
      if (allGroupsList.isEmpty && pinnedGroupsList.isEmpty) {
        emit(GroupsListIsEmptyState());
      } else {
        emit(AllGroupsListLoadedState(allGroupsList, pinnedGroupsList));
      }
    } catch (e) {
      emit(const GroupsListLoadingFailedState(
          filedMsg: 'some thing wrong happened'));
    }
  }

  void _onPinItemSwitcherEvent(
      PinGroupSwitcherEvent event, Emitter<GroupsMangerState> emit) {
    //

    event.groupItemDate.isPinned = !event.groupItemDate.isPinned;
    if (event.groupItemDate.isPinned) {
      // this action for unPin the group and make back to it's old index
      pinnedGroupsList.add(event.groupItemDate);
      allGroupsList.remove(event.groupItemDate);
      // this action for pin group
    } else {
      allGroupsList.add(event.groupItemDate);
      pinnedGroupsList.remove(event.groupItemDate);
    }

    emit(AllGroupsListLoadedState(allGroupsList, pinnedGroupsList));
  }

  void _onCheckGroupPinnedOrNotEvent(
    CheckIsGroupPinnedOrNotEvent event,
    Emitter<GroupsMangerState> emit,
  ) async {
    final List<GroupItemDate> pinnedGroupsList =
        groupsDataParentRepo.pinnedGroupsList;
    if (pinnedGroupsList.contains(event.groupItemDate)) {
      emit(const GroupItemIsPinnedState(isPinned: true));
    } else {
      emit(const GroupItemIsPinnedState(isPinned: false));
    }
  }
}
