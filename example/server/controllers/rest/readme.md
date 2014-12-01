#### Define Rest API with ForceMVC ####

You can very easily define a rest api with ForceMVC.

First of all you define your @Controller class.

```dart
@Controller
class RestController {

}
```

Now we want to define an entry point in our rest api, so we add a method.
Our api has the path /api/books, all your rest methods can be grouped under /api. 

```dart
@Controller
@RequestMapping(value: "/api")
class RestController {

  @RequestMapping(value: "/books")
  List books() {
    ...
  }
}
```

This is how our books object looks like.

```dart
class Book {
  Book(this.author, this.title);
  String author;
  String title;
}
```

But be aware that this will not work!

You need to jsonify it, you can do this by adding a method 'Map toJson()'.
Or just use our mixin Jsonify.

```dart
class Book extends Object with Jsonify {
  Book(this.author, this.title);
  String author;
  String title;
}
```

It is always better to right your own Json mapper or you can use packages in pub like exportable.
This way you have more control how your object will be transformed to json!

```dart
class Book {
  Book(this.author, this.title);
  String author;
  String title;
  
  Map toJson() {
    Map map = new Map();
    map["author"] = author;
    map["title"] = title;
    return map;
  }
}
```

Now you can return book types and it is possible for them to be transformed to a json object.

```dart
@Controller
@RequestMapping(value: "/api")
class RestController {

  @RequestMapping(value: "/books")
  List<Books> books() {
    List<Book> books = new List<Book>();
      books.add(new Book("JK Rowling", "Harry Potter"));
      books.add(new Book("Tolkin", "Hobbit"));
      return books;
  }
}
```

Now you can go to http://localhost:8080/api/books and you will see the following outcome.

```json
[{
  "author": "JK Rowling",
  "title": "Harry Potter"
},
{
  "author": "Tolkin",
  "title": "Hobbit"
}]
```

#### More ####

ForceMVC has the same principle as spring mvc. 
So if you want to add one object to all your rest calls you can do that as follow.

```dart
@ModelAttribute("datetime")
String addDateTime() {
    DateTime now = new DateTime.now();
    return now.toString();
}
```

This will always add a dateTime object in your rest api as a result to your browser. So if we add this to our RestController ...

We will get the following outcome.
```json
[[{
    "author": "JK Rowling",
    "title": "Harry Potter"
  },
  {
    "author": "Tolkin",
    "title": "Hobbit"
  }],
  {
    "datetime": "2014-11-29 18:28:05.801"
  }
]
```

You can also define the http method type on a rest call by doing the following.
```dart
@RequestMapping(value: "/post", method: RequestMethod.POST)
void post(req, Model model) {
     model.addAttribute("post", "ok");
     
     req.getPostData().then((data) {
     
     });
}
``` 
