import 'package:flutter/material.dart';
import 'package:todoapp/model/todo_item.dart';
import 'package:todoapp/util/database_client.dart';
import 'package:todoapp/util/date_formatter.dart';


class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _textEditingController = new TextEditingController();
  var db = new DatabaseHelper();
  final List<ToDoItem> _itemList = <ToDoItem>[];

  @override
    void initState() {
      super.initState();
      _readNoDoList();
    }

  void _handleSubmitted(String text) async{
    _textEditingController.clear();
    ToDoItem toDoItem = new ToDoItem(text,dateFormatted());
    int saveItemId = await db.saveItem(toDoItem);
    ToDoItem addedItem = await db.getItem(saveItemId);
    setState(() {
          _itemList.insert(0, addedItem);
        });
    print("Item saved id: $saveItemId");
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          new Flexible(child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: false,
            itemCount: _itemList.length,
            itemBuilder: (_,int index){
              return new Card(
                color: Colors.white10,
                child: new ListTile(
                  title: _itemList[index],
                  onLongPress: () => _updateItem(_itemList[index],index),
                                    trailing: new Listener(
                                      key: new Key(_itemList[index].itemName),
                                      child: new Icon(Icons.remove_circle,
                                      color: Colors.redAccent,),
                                      onPointerDown: (PointerEvent) => _deleteNodo(_itemList[index].id,index),
                                
                                    ),
                                  ),
                                );
                              }
                              )),
                              new Divider(
                                height: 1.0,
                              )
                          ],
                        ),
                  
                  
                  
                  
                        floatingActionButton: new FloatingActionButton(
                          tooltip: "Add item",
                          backgroundColor: Colors.redAccent,
                          child: new ListTile(
                            title: new Icon(Icons.add),
                          ),
                          onPressed: _showFormDialog,
                                ),
                              );
                            }
                          
                            void _showFormDialog() {
                              var alert = new AlertDialog(
                                content: new Row(children: <Widget>[
                                  new Expanded(
                                    child: new TextField(
                                      controller: _textEditingController,
                                      autofocus: true,
                                      decoration: new InputDecoration(
                                        labelText: "Item",
                                        hintText: "eg.buy stuff",
                                        icon: new Icon(Icons.note_add)
                                      ),
                                    )
                                  )
                                ],
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                    _handleSubmitted(_textEditingController.text);
                                    _textEditingController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Save")),
                                  new FlatButton(onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"),)
                                  
                                ],
                              );
                              showDialog(context: context,
                                builder: (_) {
                                  return alert;
                                }
                              );
                    }
                    _readNoDoList() async{
                      List items = await db.getItems();
                      items.forEach((item) {
                        //ToDoItem ToDoItem = ToDoItem.fromMap(item);
                        setState(() {
                                _itemList.add(ToDoItem.map(item));
                              });
                        //print("Db items: ${ToDoItem.itemName}");
                      });
                    }
                    _deleteNodo(int id,int index) async {
                      debugPrint("Deleted item!");
                      await db.deleteItem(id);
                      setState(() {
                            _itemList.removeAt(index);
                          });
                  
                    }
                  
                    _updateItem(ToDoItem item, int index) {
                      final TextEditingController _textEditController = new TextEditingController(text: item.itemName);
                      var alert = new AlertDialog(
                        title: new Text("Update Item"),
                        content: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new TextField(
                                controller: _textEditController,
                                autofocus: true,
                                decoration: new InputDecoration(
                                  labelText: "Item",
                                  hintText: "eg.buy stuff",
                                  icon: new Icon(Icons.update),
                                ),
                              ),
                            )
                        ],
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            onPressed: () async {
                              ToDoItem newItemUpdated = ToDoItem.fromMap(
                                {"itemName": _textEditController.text,
                                "dateCreated" : dateFormatted(),
                                "id": item.id
                                }
                              );
                              _handleSubmittedUpdate(index,item);
                              await db.updateItem(newItemUpdated);
                              _textEditController.clear();
                              setState(() {
                                _readNoDoList();
                              });
                              Navigator.pop(context);
                              },
                                                          child: new Text("Update")),
                                                        new FlatButton(onPressed: () => Navigator.pop(context),
                                                          child: new Text("Cancel"),)
                                                        
                                                      ],
                                                    );
                                                    showDialog(context: context,builder: (_) {
                                                      return alert;
                                                    });
                                                  }
                              
                                void _handleSubmittedUpdate(int index, ToDoItem item) {
                                  setState(() {
                                   _itemList.removeWhere((element){
                                    _itemList[index].itemName == item.itemName;
                                   }); 
                                  });
                                }
}