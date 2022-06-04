import 'package:ChatGo/bloc/discover_people/discover_people_bloc.dart';
import 'package:ChatGo/model/helper.dart';
import 'package:ChatGo/pages/conversation_room.dart';
import 'package:ChatGo/widgets/error_occured.dart';
import 'package:ChatGo/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverPeople extends StatefulWidget {
  @override
  _DiscoverPeopleState createState() => _DiscoverPeopleState();
}

class _DiscoverPeopleState extends State<DiscoverPeople> {
  TextEditingController _searchController = TextEditingController();
  DiscoverPeopleBloc _discoverPeopleBloc;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscoverPeopleBloc(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          searchBar(context),
          blocController(),
        ],
      ),
    );
  }

  Widget blocController() {
    return BlocBuilder<DiscoverPeopleBloc, DiscoverPeopleState>(
      builder: (context, state) {
        if (state is DiscoverPeopleInitial) {
          _discoverPeopleBloc = BlocProvider.of<DiscoverPeopleBloc>(context);
        }
        if (state is LoadingState) {
          return Loading();
        } else if (state is SearchLoadedState) {
          List list = [state.userName];
          return searchTiles(context, list);
        } else if (state is ErrorState) {
          return ErrorOccured(
            error: "Search Error Occured",
          );
        }
        return Container();
      },
    );
  }

  Widget searchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _searchController,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontFamily: "gilroy",
                ),
                hintText: "Search...",
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontFamily: "gilroy",
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _discoverPeopleBloc.add(InitializeSearch(
                  searchingName: _searchController.text.trim()));
            },
            icon: Icon(
              Icons.search,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300], width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget searchTiles(BuildContext context, List people) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: people.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.teal,
          ),
          onTap: () {
            Helper.otherPersonName = people[index];
            if (Helper.otherPersonName == Helper.myName) {
              final snackBar = SnackBar(
                content: Text("You can't message yourself"),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConversationRoom(
                      isNameSearched: true,
                    ),
                  ));
              _searchController.clear();
            }
          },
          title: Text(
            people[index],
            style: TextStyle(fontFamily: "gilroy", fontSize: 22),
          ),
        );
      },
    );
  }
}
