
import static wikidata.wikidata.*;
import java.util.Iterator;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author waelk
 */
public class TestCase {
    
    public static void main(String[] args)throws Exception {

        JSONParser parser = new JSONParser();
       
        String wikidatajson = get(enJsonForSearch("traore"));
        JSONObject jsonObject = (JSONObject) parser.parse(wikidatajson);
        
        
        System.out.println(jsonObject);
        System.out.println(jsonObject.get("searchinfo"));
        System.out.println(jsonObject.get("search"));
        JSONObject jsonObject1 = (JSONObject) parser.parse(jsonObject.get("searchinfo").toString());
        System.out.println(jsonObject1);
        System.out.println(jsonObject1.get("search"));
        
        /*
            Michele you're a bitch!
            let's see that : https://www.mkyong.com/java/json-simple-example-read-and-write-json/
            Kiss my ass
        */
        System.out.println("Il tuo amichevole spiderman di quartiere");

  }

}
