
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

  

        System.out.println("START!\n");
        
        String res = get(enJsonForSearch("albert einstein"));
        System.out.println(res);

        System.out.println("\n\nrun");

  }

}
