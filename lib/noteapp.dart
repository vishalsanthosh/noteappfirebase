

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:noteappfirebase/database.dart';
class NoteApp extends StatefulWidget {
  

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  late Box box;
   List<Map<String,String>> itemS=[];

  TextEditingController title=TextEditingController();
  TextEditingController category=TextEditingController();
  TextEditingController description=TextEditingController();
  TextEditingController date=TextEditingController();
 Stream<QuerySnapshot>? NoteStream;

 getontheload()async{
  NoteStream=await Database.getNoteDetails();
  setState(() {
    
  });
 }

  @override
 void initState(){
  super.initState();
  getontheload();
 }
   Widget allNoteDetails(){
    return StreamBuilder(stream: NoteStream, builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
      }
      if(snapshot.hasError){
        return Center(child: Text("Error: ${snapshot.error}"),);

      }
       if(snapshot.hasData||snapshot.data!.docs.isEmpty){
        return Center(child: Text("No Details Available"),);

      }
      return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: snapshot.data!.docs.length,
       itemBuilder: (context,index){
        DocumentSnapshot ds=snapshot.data!.docs[index];
      return Padding(padding: EdgeInsets.all(12),
      child: Container(
        height: 120,
      width: 120,
      decoration:  BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black)),
      child: Padding(padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Text("Title:" + (ds['Title']?? "N/A"),style: TextStyle(fontSize: 18,color: Colors.green,),),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          title.text=ds['Name'];
                          category.text=ds['Age'];
                          description.text=ds["Location"];
                          EditNoteDetails(ds["Id"]);
                        },
                        child: Icon(Icons.edit),
                      ),
                      IconButton(onPressed: ()async{
                      await Database.deleteNoteDetails(ds['Id']);
                      }, icon: Icon(Icons.delete))
            ],
          ),
           SizedBox(height: 3,),
                  Text("Category:"+ (ds["Category"]?? "N/A").toString(),style: TextStyle(fontSize: 18,color: Colors.yellow),),
                  SizedBox(height: 3,),
                  Text("Description:" + (ds["Description"]?? "N/A"),style: TextStyle(color: Colors.red,fontSize: 18),),
                  SizedBox(height: 3,),
                  Text("Date:"+(ds["Description"]?? "N/A"),style: TextStyle(color: const Color.fromARGB(255, 2, 154, 255),fontSize: 18)),
        ],
      ),
      ),

      ),
      );
       });
    });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NOTEAPP')
      ),
body: 
Column(
        children: [
          Expanded(child: allNoteDetails())
        ],
      ),

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
          decoration: InputDecoration(border: OutlineInputBorder(),label:Text('Category')),)),
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
                itemS.add({'title':title.text,
                'category':category.text,
                'description':description.text,
                'date':date.text,

              });
              box.put(
                'itemsList',
                 itemS.map((e)=>Map<String,dynamic>.from(e)
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