/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ner;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import javax.ws.rs.Produces;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.MediaType;

/**
 * REST Web Service
 */
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
    public static ArrayList<Entity> getEntities() throws IOException {       
        return entityList;
    }
    
    @GET
    @Produces(MediaType.APPLICATION_XML)
    public static HashMap getEntities(String TextArea) throws IOException {
        //SearchEntity currEntity;
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
