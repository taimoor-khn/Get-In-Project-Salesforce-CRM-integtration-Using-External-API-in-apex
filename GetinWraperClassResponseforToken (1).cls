global class GetinWraperClassResponseforToken 
{
    global class response 
    {
        public data data{get;set;}
    }
    global class data {
        global String session_token;
        global String token_type;
    }
}