
package ner;

import java.util.ArrayList;
import java.util.HashMap;
import javax.ws.rs.Produces;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.MediaType;

@Path("utente")
public class NERresource {
    private static String documentText = "";
    private static StanfordNLP ner = new StanfordNLP();
    private static ArrayList<Entity> entityList = new ArrayList();
    private static HashMap<Entity, Integer> entityFreq = new HashMap();

    /**
     * Creates a new instance of UserResource
     */
    public NERresource() {
    }

    
    public static String getDocumentText() {
        return documentText;
    }

    public static void setDocumentText(String documentText) {
        NERresource.documentText = documentText;
    }
    
    @GET
    @Produces(MediaType.APPLICATION_XML)
    public static ArrayList<Entity> getEntities(String TextArea) {       
        entityList = ner.recogniseNamedEntity(TextArea);
        return entityList;
    }
    
    @GET
    @Produces(MediaType.APPLICATION_XML)
    public static HashMap getFreqEntities(String TextArea) {
        Integer numCurrEntity;
        entityList = ner.recogniseNamedEntity(TextArea);
        entityFreq.clear();

        for(Entity currEntity: entityList){
            numCurrEntity = entityFreq.get(currEntity);
            if(numCurrEntity == null){
                numCurrEntity = 0;
            }
            entityFreq.put(currEntity, numCurrEntity+1);
        }
            
        return entityFreq;
    }

}
