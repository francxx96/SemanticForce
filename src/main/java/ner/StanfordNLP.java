
package ner;


import edu.stanford.nlp.ling.CoreAnnotations;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.ling.IndexedWord;
import edu.stanford.nlp.pipeline.Annotation;
import edu.stanford.nlp.pipeline.StanfordCoreNLP;
import edu.stanford.nlp.semgraph.SemanticGraph;
import edu.stanford.nlp.semgraph.SemanticGraphCoreAnnotations;
import edu.stanford.nlp.util.CoreMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Set;

public class StanfordNLP {

    private Properties props; // The Properties class represents a persistent set of properties
    private StanfordCoreNLP pipeline; // Stanford CoreNLP provides a set of human language technology tools
    
    public StanfordNLP() {
        props = new Properties(); // set up pipeline properties
        // set the list of annotators to run
        props.put("annotators", "tokenize, ssplit, pos, lemma, ner, parse"); //, regexner, parse, mention, entitymentions");
        props.put("ner.applyFineGrained", "false");
        pipeline = new StanfordCoreNLP(props); // build pipeline
    }

    
    public ArrayList<Entity> recogniseNamedEntity(String doc) { 
        if(!doc.endsWith("."))
            doc += ".";
        
        Annotation document = new Annotation(doc); // create a doc object
        pipeline.annotate(document); // annnotate the doc
        List<CoreMap> sentences = document.get(CoreAnnotations.SentencesAnnotation.class); // get the sentences contained in an annotation
        
        boolean inEntity = false;
        int offset = 0;
        String text, pos, namedEntity, currEntity = "", currEntityType = "O";
        ArrayList<Entity> entityList = new ArrayList<>();

        for (CoreMap sentence : sentences) {
            // parse tree of the current sentence
            //Tree tree = sentence.get(TreeAnnotation.class);
            //System.out.println(tree);
            
            // dependency parse
            SemanticGraph semanticGraph = sentence.get(SemanticGraphCoreAnnotations.BasicDependenciesAnnotation.class);
            //System.out.println(semanticGraph.toList());
            //System.out.println(semanticGraph);
            
            for (CoreLabel token : sentence.get(CoreAnnotations.TokensAnnotation.class)) { //tokens contained by an annotation
                text = token.get(CoreAnnotations.TextAnnotation.class);
                pos = token.get(CoreAnnotations.PartOfSpeechAnnotation.class);
                namedEntity = token.get(CoreAnnotations.NamedEntityTagAnnotation.class);
                //System.out.println("Token=" + token + "*\tText=" + text + "*\tPOS=" + pos + "*\tNER=" + namedEntity);
                             
                if(inEntity){ 
                    if (!currEntityType.equals(namedEntity)) { //"O".equals(namedEntity) 
                        inEntity = false; 
                        Entity entity = new Entity(currEntity, currEntityType, offset);
                        
                        Set<IndexedWord> parents = semanticGraph.getParents(new IndexedWord(token));
                        Set<IndexedWord> children = semanticGraph.getChildren(new IndexedWord(token));
                        //System.out.println("Parents: " + parents + "\tChildren: " + children);
                        
                        ArrayList<String> relatives = getEntityRelated(parents);
                        relatives.addAll(getEntityRelated(children));
                        entity.setKeyWords(relatives);
                        
                        System.out.println("\n\nExtracted: " + entity);
                        entityList.add(entity);
                        //System.out.println("entityLen="+entityLength+"\toffset="+offset+"\tpos="+(offset-entityLength));                   
                    }else{
                        currEntity += " " + text.trim();
                        //entity.setName(entity.getName() + " " + text);//token.originalText();
                    }
                }
                if(!inEntity){
                    if (!"O".equals(namedEntity)) { // eliminate the Other categories
                        inEntity = true;
                        currEntity = text.trim();
                        currEntityType = namedEntity;
                        offset = token.beginPosition();
                    }
                }
            }
        }
        //System.out.println(entityList.toString());    
        return entityList;                          
    }
    
    private ArrayList<String> getEntityRelated(Set<IndexedWord> entitiesIW){
        ArrayList<String> entityList = new ArrayList<>();
        
        for(IndexedWord iw: entitiesIW){
            entityList.add(iw.originalText());
        }
        
        return entityList;
    }

}
