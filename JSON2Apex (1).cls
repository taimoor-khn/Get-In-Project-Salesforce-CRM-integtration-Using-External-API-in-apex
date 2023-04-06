global class JSON2Apex  {
    
    public class Data_Z {
		public Integer current_page {get;set;} 
		public String first_page_url {get;set;} 
		public Integer from_Z {get;set;} // in json: from
		public Integer last_page {get;set;} 
		public String last_page_url {get;set;} 
		public String next_page_url {get;set;} 
		public String path {get;set;} 
		public Integer per_page {get;set;} 
		public String prev_page_url {get;set;} 
		public Integer to {get;set;} 
		public Integer total {get;set;} 
		public List<Data> data {get;set;} 

		public Data_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'current_page') {
							current_page = parser.getIntegerValue();
						} else if (text == 'first_page_url') {
							first_page_url = parser.getText();
						} else if (text == 'from') {
							from_Z = parser.getIntegerValue();
						} else if (text == 'last_page') {
							last_page = parser.getIntegerValue();
						} else if (text == 'last_page_url') {
							last_page_url = parser.getText();
						} else if (text == 'next_page_url') {
							next_page_url = parser.getText();
						} else if (text == 'path') {
							path = parser.getText();
						} else if (text == 'per_page') {
							per_page = parser.getIntegerValue();
						} else if (text == 'prev_page_url') {
							prev_page_url = parser.getText();
						} else if (text == 'to') {
							to = parser.getIntegerValue();
						} else if (text == 'total') {
							total = parser.getIntegerValue();
						} else if (text == 'data') {
							data = arrayOfData(parser);
						} else {
							//System.debug(LoggingLevel.WARN, 'Data_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Data_Z data {get;set;} 

	public JSON2Apex(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						data = new Data_Z(parser);
					} else {
						//System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Data {
		public String id {get;set;} 
		public String name {get;set;} 
		public String phone {get;set;} 
		public String email {get;set;} 
		public String mailing {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'phone') {
							phone = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'mailing') {
							mailing = parser.getText();
						} else {
						//	System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static JSON2Apex parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new JSON2Apex(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	




    private static List<Data> arrayOfData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
    }
}