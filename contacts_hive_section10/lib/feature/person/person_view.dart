import 'package:contacts_hive_section10/data/Person/Person.dart';
import 'package:contacts_hive_section10/domain/Person/Person_entity.dart';
import 'package:contacts_hive_section10/feature/person/person_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'person_bloc.dart';
import 'person_event.dart';

class PersonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PersonBloc()..add(ReadContactsEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final personBloc = BlocProvider.of<PersonBloc>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "My contacts",
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              onPressed: () {
                TextEditingController _nameController = TextEditingController();
                TextEditingController _nickNameController =
                    TextEditingController();
                GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                AlertDialog alert = AlertDialog(
                  title: Text("Add Contact"),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: (String? name) {
                            if (name == null || name.isEmpty) {
                              return "Please enter some name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Name",
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          controller: _nickNameController,
                          validator: (String? name) {
                            if (name == null || name.isEmpty) {
                              return "Please enter some nick Name!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Nick Name ....",
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Center(
                      child: TextButton(
                        child: Text(
                          "OK",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            Person person = Person(
                                name: _nameController.text,
                                nickName: _nickNameController.text);
                            personBloc.add(AddContactEvent(person: person));
                          }
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.purple.withOpacity(0.5))),
                      ),
                    ),
                  ],
                );
                showDialog(context: context, builder: (ctx) => alert);
              },
              icon: Icon(
                Icons.add_box_rounded,
                size: 50.0,
                color: Colors.purple,
              ))
        ],
      ),
      body: BlocBuilder<PersonBloc, PersonState>(
        bloc: personBloc,
        builder: (ctx, state) {
          if (state.contactsList == null) {
            return Center(
              child: Text(
                state.message ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else {
            return _mainWidget(state.contactsList);
          }
          return Container();
        },
      ),
    );
  }

  Widget _mainWidget(List<PersonEntity>? contacts) {
    return ListView.builder(
        itemCount: contacts?.length ?? 0,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (ctx, index) {
          return Container(
            margin: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  child: Image.asset(
                    index % 2 == 0
                        ? "assets/images/male.jpg"
                        : "assets/images/female.jpg",
                    fit: BoxFit.contain,
                    scale: 40,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts?[index].name ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(contacts?[index].nickName ?? ""),
                  ],
                )
              ],
            ),
          );
        });
  }
}
