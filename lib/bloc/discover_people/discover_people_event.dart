part of 'discover_people_bloc.dart';

abstract class DiscoverPeopleEvent extends Equatable {
  const DiscoverPeopleEvent();

  @override
  List<Object> get props => [];
}

class InitializeSearch extends DiscoverPeopleEvent {
  final String searchingName;
  InitializeSearch({this.searchingName});
}

class YouCantMessageYourSelf extends DiscoverPeopleEvent {}
