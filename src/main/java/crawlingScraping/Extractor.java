/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package crawlingScraping;

import com.google.gson.Gson;
import de.l3s.boilerpipe.BoilerpipeProcessingException;
import de.l3s.boilerpipe.document.TextDocument;
import de.l3s.boilerpipe.extractors.CommonExtractors;
import de.l3s.boilerpipe.sax.BoilerpipeSAXInput;
import de.l3s.boilerpipe.sax.HTMLDocument;
import de.l3s.boilerpipe.sax.HTMLFetcher;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PUT;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.MediaType;
import org.apache.logging.log4j.LogManager;
import org.json.simple.parser.ParseException;
import org.xml.sax.SAXException;

/**
 * REST Web Service
 *
 * @author aless
 */
@Path("WebEstrazione")
public class Extractor {

    @Context
    private UriInfo context;
    static ArrayList<String> extractedUrl = new ArrayList();
    static App crawler;
    static ArrayList<Article> articles = new ArrayList();
    
    private static final org.apache.logging.log4j.Logger logger = LogManager.getLogger(Extractor.class.getName() );
    private static String NUMBER_OF_SHARDS = "number_of_shards";
    private static String NUMBER_OF_REPLICAS = "number_of_replicas";

    private static String CLUSTER_NAME = "cluster_name";
    private static String INDEX_NAME = "index_name";
    private static String INDEX_TYPE = "index_type";
    private static String IP = "master_ip";
    private static String PORT = "master_port";
    private static int indi;
    

    /**
     * Creates a new instance of Estractor
     */
    public Extractor() {
    }

    /**
     * Retrieves representation of an instance of EstrazioneWebProva.Estractor
     * @return an instance of java.lang.String
     */
    @GET
    @Produces(MediaType.APPLICATION_XML)
    public String getXml() {
        //TODO return proper representation object
        throw new UnsupportedOperationException();
    }
    @GET
    @Path("articolo/{url}")
    @Produces(MediaType.APPLICATION_JSON)
    public static String getJson(@PathParam("url") String url) throws Exception{
        final HTMLDocument htmlDoc = HTMLFetcher.fetch(new URL(url));
        final TextDocument doc = new BoilerpipeSAXInput(htmlDoc.toInputSource()).getTextDocument();
        String content = CommonExtractors.ARTICLE_EXTRACTOR.getText(doc);
        String contentitle = doc.getTitle();
        Article articlea = new Article(contentitle, content, url);
        Gson gson = new Gson();     
        String userJson = gson.toJson(articlea);
        System.out.println(userJson);
        return userJson;
    }
    
    @GET
    @Path("articoloa/{url}")
    @Produces(MediaType.APPLICATION_JSON)
    public static Article getArticle(@PathParam("url") String url) throws Exception {
        HTMLDocument htmlDoc;
        TextDocument doc;
        Article article = new Article();
        article.setUrl(url);
        
        try {
            
            htmlDoc = HTMLFetcher.fetch(new URL(url));
            doc = new BoilerpipeSAXInput(htmlDoc.toInputSource()).getTextDocument();
            String title = doc.getTitle();
            String text = CommonExtractors.ARTICLE_EXTRACTOR.getText(doc);
            article.setText(text);
            article.setTitle(title);
            
        } catch (MalformedURLException | SAXException | BoilerpipeProcessingException ex) {
            Logger.getLogger(App.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            System.out.println("Cannot retrieve article from the given URL: " + url);
        }
        
        return article;
    }
    
    @GET
    @Path("siti/{crawl}")
    public static String getXml(@PathParam("crawl") String crawl, String cDepth) throws Exception{
        crawler = new App(crawl, cDepth);
        extractedUrl = crawler.readExtractedUrl();
        return extractedUrl.toString();
    }
    
    @GET
    @Path("articolob")
    @Produces(MediaType.TEXT_HTML)
    public static ArrayList<Article> getExtractedArticles() throws Exception, IOException, BoilerpipeProcessingException{
        articles = crawler.extraction(extractedUrl);
        return articles;
    }
    
    @GET
    @Path("artestrazione/{arti}")
    @Produces(MediaType.APPLICATION_JSON)
    public static void getJSONSavatage(@PathParam("docum") String docum) throws IOException{
        crawler.saveToJson(articles, docum);
    }
    
    @GET
    @Path("{ciaone}")
    public static void elastic(@PathParam("ciaone") String ind, String file){
        
        PropertyReader properties = null;
        ElasticSearchConnector es = null;

        try {
            properties = new PropertyReader( getRelativeResourcePath( "config.properties" ) );
        } catch (FileNotFoundException ex) {
        }

        String numberOfShards = properties.read( NUMBER_OF_SHARDS );
        String numberOfReplicas = properties.read( NUMBER_OF_REPLICAS );
        String clusterName = properties.read( CLUSTER_NAME );
        String indexName = ind + "-" + indi;
        String indexType = properties.read( INDEX_TYPE );
        String ip = properties.read( IP );

        int port = Integer.parseInt( properties.read( PORT ) );
        
        try {
            es = new ElasticSearchConnector( clusterName, ip, port );
        } catch (UnknownHostException ex) {}
        
        es.isClusterHealthy();
        
        if( !es.isIndexRegistered( indexName ) ) {
            es.createIndex( indexName, numberOfShards, numberOfReplicas );
                           
            try {
                es.bulkInsert( indexName, indexType, getRelativeResourcePath(file));
            } catch (ParseException ex) {
                Logger.getLogger(Extractor.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                indi++;
            }
            /*
            else{
                JOptionPane.showMessageDialog(rootPane, "L'indice è gia presente in elasticsearch" + "\n" + "Prego cambiare nome");
            }
            if(jTextArea1.getText().length()==1)
                JOptionPane.showMessageDialog(rootPane, "ERRORE!" +"\n" + "Il nome dell'indice non rispetta i requisiti" + "\n" + "Prego cambiare nome");
            */
            es.close();
        }
    }
    
   private static String getRelativeResourcePath(String resource) throws FileNotFoundException{
	if( resource == null || resource.equals("") ) 
            throw new IllegalArgumentException( resource );
	
        URL url = Extractor.class.getClassLoader().getResource( resource );
	if( url == null ) 
            throw new FileNotFoundException( resource );
        return url.getPath();
    }
    /**
     * PUT method for updating or creating an instance of Estractor
     * @param content representation for the resource
     */
    @PUT
    @Consumes(MediaType.APPLICATION_XML)
    public void putXml(String content) {
    }
}
