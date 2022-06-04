part of 'discover_people_bloc.dart';

abstract class DiscoverPeopleState extends Equatable {
  const DiscoverPeopleState();

  @override
  List<Object> get props => [];
}

class DiscoverPeopleInitial extends DiscoverPeopleState {}

class LoadingState extends DiscoverPeopleState {}

class SearchLoadedState extends DiscoverPeopleState {
  final String userName;
  SearchLoadedState({this.userName});
}

class ErrorState extends DiscoverPeopleState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}
