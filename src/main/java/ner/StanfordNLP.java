package ner;

import edu.stanford.nlp.ling.CoreAnnotations;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.pipeline.Annotation;
import edu.stanford.nlp.pipeline.StanfordCoreNLP;
import edu.stanford.nlp.util.CoreMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;


public class StanfordNLP {

    private Properties props; // The Properties class represents a persistent set of properties
    
    public StanfordNLP() {
        props = new Properties(); // set up pipeline properties
        // Maps the specified key to the specified value in this dictionary
        props.put("annotators", "tokenize, ssplit, pos, lemma, ner");  // set the list of annotators to run
    }

    
    public ArrayList<Entity> recogniseNamedEntity(String doc) {  
        // Stanford CoreNLP provides a set of human language technology tools
        StanfordCoreNLP pipeline = new StanfordCoreNLP(props); // build pipeline
        Annotation document = new Annotation(doc); // create a doc object
        pipeline.annotate(document); // annnotate the doc
        List<CoreMap> sentences = document.get(CoreAnnotations.SentencesAnnotation.class); // get the sentences contained in an annotation

        int offset=0;
        boolean inEntity = false;
        String currentEntity = "", currentEntityType = "";
        ArrayList<Entity> entityList = new ArrayList<>();
        
        for (CoreMap sentence : sentences) {
            for (CoreLabel token : sentence.get(CoreAnnotations.TokensAnnotation.class)) { //tokens contained by an annotation
                String text = token.get(CoreAnnotations.TextAnnotation.class);
                String pos = token.get(CoreAnnotations.PartOfSpeechAnnotation.class);
                String namedEntity = token.get(CoreAnnotations.NamedEntityTagAnnotation.class);
                //System.out.println("Token=" + token + "*\tText=" + text + "*\tPOS=" + pos + "*\tNER=" + namedEntity);

                if (!inEntity) {
                    if (!"O".equals(namedEntity)) { // eliminate the Other categories
                        inEntity = true;
                        currentEntity = "";
                        currentEntityType = namedEntity;
                        offset = token.beginPosition();
                    }
                }
                if (inEntity) {
                    if (!currentEntityType.equals(namedEntity)) { //"O".equals(namedEntity) 
                        inEntity = false;
                        Entity entity = new Entity();
                        entity.setName(currentEntity.trim()); // trim() returns a copy with leading and trailing white sapce removed
                        System.out.println("Extracted " + currentEntity.trim());
                        entity.setType(currentEntityType);
                        entity.setPosition(offset);
                        entityList.add(entity);
                        //System.out.println("entityLen="+entityLength+"\toffset="+offset+"\tpos="+(offset-entityLength));
                    }else{
                        currentEntity += " " + text;//token.originalText();
                    }
                }
            }
        }
        
        NERresource.setDocumentText(doc);
        //System.out.println(entityList.toString());    
        return entityList;                          
    }

}
