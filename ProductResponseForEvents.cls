//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
// The supplied json has fields with names that are not valid in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.

public class ProductResponseForEvents {

	public class Data {
		public Integer id {get;set;} 
		public String name {get;set;} 
		public String comment {get;set;} 
		public Integer quantity {get;set;} 
		public Integer remaining {get;set;} 
		public Integer limits {get;set;} 
		public Integer price {get;set;} 
		public String start_date {get;set;} 
		public String end_date {get;set;} 
		public Integer status {get;set;} 
		public Integer reg {get;set;} 
		public Integer sort_Z {get;set;} // in json: sort
		public String last_update {get;set;} 
		public String category_ids {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'comment') {
							comment = parser.getText();
						} else if (text == 'quantity') {
							quantity = parser.getIntegerValue();
						} else if (text == 'remaining') {
							remaining = parser.getIntegerValue();
						} else if (text == 'limits') {
							limits = parser.getIntegerValue();
						} else if (text == 'price') {
							price = parser.getIntegerValue();
						} else if (text == 'start_date') {
							start_date = parser.getText();
						} else if (text == 'end_date') {
							end_date = parser.getText();
						} else if (text == 'status') {
							status = parser.getIntegerValue();
						} else if (text == 'reg') {
							reg = parser.getIntegerValue();
						} else if (text == 'sort') {
							sort_Z = parser.getIntegerValue();
						} else if (text == 'last_update') {
							last_update = parser.getText();
						} else if (text == 'category_ids') {
							category_ids = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public List<Data> data {get;set;} 

	public ProductResponseForEvents(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						data = arrayOfData(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'ProductResponseForEvents consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static ProductResponseForEvents parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ProductResponseForEvents(parser);
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