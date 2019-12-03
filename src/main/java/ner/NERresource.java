
package ner;

import java.util.ArrayList;
import java.util.HashMap;


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
    

    public static ArrayList<Entity> getEntities(String TextArea) {       
        entityList = ner.recogniseNamedEntity(TextArea);
        return entityList;
    }
    

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
