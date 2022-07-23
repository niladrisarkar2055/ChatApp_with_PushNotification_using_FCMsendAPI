import 'package:flutter/material.dart';
import 'package:listview_in_blocpattern/database_manager.dart';

class MultiSelect extends StatefulWidget {
  final List<String> userEmails;
  String senderUID;

  MultiSelect({
    Key? key,
    required this.userEmails,
    required this.senderUID,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedUsers = [];
  final List<String> receiverTokens = [];
  TextEditingController grpNameController = TextEditingController();

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedUsers.add(itemValue);
      } else {
        _selectedUsers.remove(itemValue);
      }
    });
  }

  fetchReceiverTokens(List<String> emailsList) async {
    int n = emailsList.length;
    List result = await DatabaseManager().fetchUserList();
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < result.length; j++) {
        if (emailsList[i] == result[j]['Email']) {
          receiverTokens.add(result[j]['Token'][0]);
        }
      }
    }

    for (int i = 0; i < result.length; i++) {
      if (widget.senderUID == result[i]['Email']) {
        receiverTokens.add(result[i]['Token'][0]);
      }
    }
    return receiverTokens;
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() async {
    await fetchReceiverTokens(_selectedUsers);
    DatabaseManager().createGroup(grpNameController.text.trim(),
        widget.senderUID, _selectedUsers, receiverTokens);
    Navigator.pop(context);
    
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
          child: Column(
        children: [
          Text('Create New Group'),
          TextField(
            controller: grpNameController,
            decoration: InputDecoration(hintText: 'Group Name'),
          )
        ],
      )),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.userEmails
              .map((userEmails) => CheckboxListTile(
                    value: _selectedUsers.contains(userEmails),
                    title: Text(userEmails),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) =>
                        _itemChange(userEmails, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}

