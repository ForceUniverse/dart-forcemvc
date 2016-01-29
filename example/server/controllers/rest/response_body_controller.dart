part of example_forcedart;

@Controller
@RequestMapping(value: "/rb")
class ResponseBodyController {
  int count = 0;

  RestController() {
    count = 1;
  }

  @ModelAttribute("datetime")
  String addDateTime() {
    DateTime now = new DateTime.now();
    return now.toString();
  }

  @RequestMapping(value: "/count")
  @ResponseBody
  int countJson(req, Model model) {
    count++;
    return count;
  }

  @RequestMapping(value: "/map")
  @ResponseBody
  Map mapJson() {
      Map map = new Map();
      map["count"] = "$count";
      map["bla"] = "hallo";
      return map;
  }

  @RequestMapping(value: "/list")
  @ResponseBody
  List lists() {
      List<String> books = new List<String>();
      books.add("just a list");
      books.add("another entry");
      return books;
  }

  @RequestMapping(value: "/books")
  @ResponseBody
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
