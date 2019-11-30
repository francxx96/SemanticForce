
package wikidata;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class wikidata {
    
    public static String get(String urlToRead) throws Exception {
        StringBuilder result = new StringBuilder();
        URL url = new URL(urlToRead);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        try (BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String line;
            while ((line = rd.readLine()) != null) {
                result.append(line);
            }
        }
        return result.toString();
    }
    
    public static String enJsonForSearch(String subject){
        return "https://www.wikidata.org/w/api.php?"+"action=wbsearchentities&search="+subject+"&language=en&format=json";
    }
    
    public static String enJsonForEntity(String id){
        return "https://www.wikidata.org/w/api.php?action=wbgetentities&ids="+id+"&languages=en&format=json";
    
    }
    
    
    public static ArrayList<String[]> executeGet(String itemLabel) throws Exception{
        JSONParser parser = new JSONParser();
        String wikidatajson = get(enJsonForSearch(itemLabel));
        JSONObject jsonObject = (JSONObject) parser.parse(wikidatajson);
        System.out.println("JsonObject "+jsonObject + "\n");
        JSONArray list = new JSONArray();
        list = (JSONArray) parser.parse(jsonObject.get("search").toString());
        ArrayList<String[]> returnedList = new ArrayList<String[]>();
        System.out.println("Sono arrivato qua ");
        int i = 0;
        
         for(i=0;i<list.size();i++){
            String item = list.get(i).toString();
            jsonObject = (JSONObject) parser.parse(item);
            String label = jsonObject.get("label").toString();
            String url = jsonObject.get("url").toString();
            
   
            String [] container = {label,url};
           
            returnedList.add(container);
            
            
        }
        
        //System.out.println("Lista da generare " + returnedList);
        return returnedList;
        
    }

}
