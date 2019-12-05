
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
       
        String wikidatajson = getwael(enJsonForSearch("traore"));
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

        String res = getwael("https://query.wikidata.org/sparql?query=SELECT%20DISTINCT%20%3Fitem%20%3FitemLabel%20%3Fdesc%20%0AWHERE%20%0A%7B%0A%20%20%3Fitem%20wdt%3AP31%20wd%3AQ5%3B%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%20%20schema%3Adescription%20%3Fdesc%3B%0A%20%20%20%20%20%20%20%20rdfs%3Alabel%20%3FitemLabel.%0A%20%20FILTER%28LANG%28%3FitemLabel%29%20%3D%20%22en%22%29.%0A%20%20FILTER%28LANG%28%3Fdesc%29%20%3D%20%22en%22%29.%0A%20%20FILTER%20contains%28%3FitemLabel%2C%22Albert%22%29.%0A%20%20%0A%7D%0ALIMIT%203");
        System.out.println(res);


  }

}
