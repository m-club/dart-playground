import 'package:http/http.dart' as http;

void main() async {
    //print("hello dart!");
    final url = "http://www.imandui.com/example";
    final response = await http.get(url);
    print(response.body);
}
