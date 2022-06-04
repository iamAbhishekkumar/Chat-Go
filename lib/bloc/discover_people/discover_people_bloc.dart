import 'dart:async';

import 'package:ChatGo/services/chatDatabase.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'discover_people_event.dart';
part 'discover_people_state.dart';

class DiscoverPeopleBloc
    extends Bloc<DiscoverPeopleEvent, DiscoverPeopleState> {
  ChatDatabase _chatDatabase = ChatDatabase();
  DiscoverPeopleBloc() : super(DiscoverPeopleInitial());

  @override
  Stream<DiscoverPeopleState> mapEventToState(
    DiscoverPeopleEvent event,
  ) async* {
    if (event is InitializeSearch) {
      yield LoadingState();
      try {
        String name;
        QuerySnapshot snapshot =
            await _chatDatabase.getUserInfo(username: event.searchingName);

        name = snapshot.docs[0].data()['name'];

        if (name != null) yield SearchLoadedState(userName: name);
      } catch (e) {
        print(e.toString());
        yield ErrorState(e.toString());
      }
    }
  }
}
