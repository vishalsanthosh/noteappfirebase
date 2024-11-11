import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
class NoteApp extends StatefulWidget {
  

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  late Box box;
   List<Map<String,String>> itemList=[];

  TextEditingController title=TextEditingController();
  TextEditingController category=TextEditingController();
  TextEditingController description=TextEditingController();
  TextEditingController date=TextEditingController();
 
  @override
  void initState(){
    super.initState();
     box=Hive.box("MyBox");
     final storedItems=box.get('itemsList');
     if(storedItems is List){
      itemList=List<Map<String,String>>.from(
        storedItems.map((e)=>Map<String,String>.from(e))
      );
     }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NOTEAPP')
      ),
body: 
GridView.builder(
  itemCount: itemList.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
 itemBuilder: (
  
  context,index){
  final item=itemList[index];
  return Container(
    height: 300,
    width: double.infinity,
    child: Column(
      children: [
        Text(item['title']?? 'No title'),
        Text(item['category']?? 'No catrgory'),
        Text(item['description']?? 'No description'),
        Text(item['date']?? 'No date')
      ],
    ),
  );
 }),

floatingActionButton: FloatingActionButton(onPressed: (){
      showModalBottomSheet(context: context, builder: (BuildContext context){
        
        return Container(
height: 350,
width: double.infinity,
child: Padding(
  padding: const EdgeInsets.all(15.0),
  child: Column(
    children: [
      SizedBox(
        height: 50,
        width: 300,
        child: TextField(
          controller: title,
          decoration: InputDecoration(border: OutlineInputBorder(),label:Text('Title')),)),
      SizedBox(height: 10),
       SizedBox(
        height:50,
        width: 300,
        child: TextField(
          controller: category,
          decoration: InputDecoration(border: OutlineInputBorder(),label:Text('Categort')),)),
      SizedBox(height: 10),
       SizedBox(
        height: 50,
        width: 300,
        child: TextField(
          controller: description,
          decoration: InputDecoration(border: OutlineInputBorder(),label:Text('Description')),)),
      SizedBox(height: 10),
       SizedBox(
        height: 50,
        width: 300,
        child: TextField(
          controller: date,
          decoration: InputDecoration(border: OutlineInputBorder(),label:Text('Date')),)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(onPressed: (){
              setState(() {
                itemList.add({'title':title.text,
                'category':category.text,
                'description':description.text,
                'date':date.text,

              });
              box.put(
                'itemsList',
                 itemList.map((e)=>Map<String,dynamic>.from(e)
                ).toList());
            });
              title.clear();
              category.clear();
              description.clear();
              date.clear();
            Navigator.pop(context);
            },

             child: Text('Add')
             ),
            SizedBox(width: 5),
              TextButton(onPressed: (){
                Navigator.of(context);
              }, child: Text('Cancel')),
          ],
        )
      
    ],
  ),
),

        );
      });
    },
    child: Icon(Icons.add),),
    );
  }
}