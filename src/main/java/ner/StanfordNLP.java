
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
    private static StanfordNLP instance = null;
    
    private StanfordNLP() {
        
    }

    public static StanfordNLP getStanfordNLP(){
        if(instance == null){
            instance = new StanfordNLP();
            instance.props = new Properties(); // set up pipeline properties
            // set the list of annotators to run
            instance.props.put("annotators", "tokenize, ssplit, pos, lemma, ner, parse"); //, regexner, parse, mention, entitymentions");
            instance.props.put("ner.applyFineGrained", "false");
            instance.pipeline = new StanfordCoreNLP(instance.props); // build pipeline
        }
        return instance;
    }
    
    public ArrayList<Entity> recogniseNamedEntity(String doc) { 
        if(!doc.endsWith("."))
            doc += ".";
        
        Annotation document = new Annotation(doc); // create a doc object
        pipeline.annotate(document); // annnotate the doc
        List<CoreMap> sentences = document.get(CoreAnnotations.SentencesAnnotation.class); // get the sentences contained in an annotation
        
        boolean inEntity = false;
        int startPos = 0, endPos = 0;
        IndexedWord currToken = new IndexedWord();
        String text, pos, namedEntity, currEntity = "", currEntityType = "O";
        ArrayList<Entity> entityList = new ArrayList<>();

        for (CoreMap sentence : sentences) {
            // parse tree of the current sentence
            //Tree tree = sentence.get(TreeAnnotation.class);
            //System.out.println(tree);
            
            // dependency parse
            SemanticGraph semanticGraph = sentence.get(SemanticGraphCoreAnnotations.BasicDependenciesAnnotation.class);
            removePunctFromSemGraph(semanticGraph);
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
                        Entity entity = new Entity(currEntity, currEntityType, startPos, endPos);
                        
                        Set<IndexedWord> parents = semanticGraph.getParents(currToken);
                        Set<IndexedWord> children = semanticGraph.getChildren(currToken);
                        //System.out.println("Parents: " + parents + "\tChildren: " + children);
                        ArrayList<String> relatives = getEntityRelated(parents);
                        relatives.addAll(getEntityRelated(children));
                        entity.setKeyWords(relatives);
                        
                        System.out.println("Extracted\t" + entity);
                        entityList.add(entity);
                        //System.out.println("entityLen="+entityLength+"\toffset="+startPos+"\tpos="+(startPos-entityLength));                   
                    }else{
                        currEntity += " " + text.trim();
                        endPos = token.beginPosition() + text.length();
                        //currToken = new IndexedWord(token);
                    }
                }
                if(!inEntity){
                    if (!"O".equals(namedEntity)) { // eliminate the Other categories
                        inEntity = true;
                        currEntity = text.trim();
                        currEntityType = namedEntity;
                        startPos = token.beginPosition();
                        endPos = token.beginPosition() + text.length();
                        currToken = new IndexedWord(token);
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

    private void removePunctFromSemGraph(SemanticGraph semanticGraph){
        String punctuations = "`~!@#%^*()_+{}|:\"<>?=[];'./,";
        
        for(IndexedWord vertex : new ArrayList<>(semanticGraph.vertexSet())){
   
            if(punctuations.contains(vertex.value())){
                semanticGraph.removeVertex(vertex);
            } 
        }   
    }
    
}
