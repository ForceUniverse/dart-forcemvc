part of example_forcedart;

class Book extends Object with Jsonify {
  Book(this.author, this.title);
  String author;
  String title;
}

@Controller
@RequestMapping(value: "/api")
class ApiController {
  int count = 0;

  ApiController() { 
    count = 1;
  }

  @ModelAttribute("datetime")
  String addDateTime() {
    DateTime now = new DateTime.now();
    return now.toString();
  }

  @RequestMapping(value: "/count")
  void countJson(req, Model model) {
    count++;
    model.addAttribute("count", "$count");
    model.addAttribute("bla", "hallo");
  }

  @RequestMapping(value: "/map")
  Map mapJson() {
      Map map = new Map();
      map["count"] = "$count";
      map["bla"] = "hallo";
      return map;
  }

  @RequestMapping(value: "/list")
  List lists() {
      List<String> books = new List<String>();
      books.add("just a list");
      books.add("another entry");
      return books;
  }

  @RequestMapping(value: "/books")
  List books() {
      List<Book> books = new List<Book>();
      books.add(new Book("JK Rowling", "Harry Potter"));
      books.add(new Book("Tolkin", "Hobbit"));
      return books;
  }

  @RequestMapping(value: '/book/1')
  @ResponseBody
  Book book() {
    return new Book("JK Rowling", "Harry Potter");
  }

  @RequestMapping(value: "/book", method: RequestMethod.POST)
  Future post(req, Model model) {
     model.addAttribute("post", "ok");

     req.getPostParams().then((data) {
               req.async(data);
             });
     return req.asyncFuture;
  }
}
