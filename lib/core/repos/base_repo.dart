class BaseRepo {

  String processUrl (String url, Map<String, String> queries) {
    int i = 0;
    if (queries != null) {
      queries.forEach((key, value) {
        if (i == 0 ){
          url += "?";
        }
        else {
          url += "&";
        }
        url += key + "=" + value;
        i++;
      });
    }

    return url;
  }

}