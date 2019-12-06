
package ner;

import java.util.ArrayList;
import java.util.HashMap;


/**
 * The class provides methods of accessing resources obtained with stanford.
 * @author emili
 */
public class NERresource {
    
    private static String documentText = "";
    private static StanfordNLP ner = StanfordNLP.getStanfordNLP();
    private static ArrayList<Entity> entityList = new ArrayList();
    private static HashMap<Entity, Integer> entityFreq = new HashMap();


    public NERresource() {
    }

    
    public static String getDocumentText() {
        return documentText;
    }

    public static void setDocumentText(String documentText) {
        NERresource.documentText = documentText;
    }
    
    public static ArrayList<Entity> getEntities(String text) {       
        entityList = ner.recogniseNamedEntity(text);
        NERresource.setDocumentText(text);
        return entityList;
    }

    public static HashMap getFreqEntities(String text) {
        Integer numCurrEntity;
        entityList = ner.recogniseNamedEntity(text);
        NERresource.setDocumentText(text);
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
