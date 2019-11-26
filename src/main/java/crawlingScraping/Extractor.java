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
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.IllegalCharsetNameException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PUT;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.MediaType;
import org.xml.sax.SAXException;

/**
 * REST Web Service
 *
 * @author aless
 */
@Path("WebEstrazione")
public class Extractor {
    static App crawler;
    static ArrayList<String> extractedUrl = new ArrayList();
    static ArrayList<Article> articles = new ArrayList();    

    /**
     * Creates a new instance of Estractor
     */
    public Extractor() {
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
        } catch (IOException | IllegalCharsetNameException ex) {
            System.out.println("Cannot retrieve article from the given URL: " + url);
        }
        
        return article;
    }
    
    /**
     * Retrieves representation of an instance of EstrazioneWebProva.Estractor
     * 
     * @param crawl
     * @param cDepth
     * @return an instance of java.lang.String
     * @throws Exception 
     */
    @GET
    @Path("siti/{crawl}")
    @Produces(MediaType.APPLICATION_XML)
    public static String getXml(@PathParam("crawl") String crawl, String cDepth) throws Exception{
        crawler = new App(crawl, cDepth);
        extractedUrl = crawler.readExtractedUrl();
        return extractedUrl.toString();
    }
    
    @GET
    @Path("articolob")
    @Produces(MediaType.TEXT_HTML)
    public static ArrayList<Article> getExtractedArticles(int nArticles) throws Exception, IOException, BoilerpipeProcessingException{
        articles = crawler.extraction(extractedUrl,nArticles);
        return articles;
    }
    
    @GET
    @Path("artestrazione/{arti}")
    @Produces(MediaType.APPLICATION_JSON)
    public static void getJSONSavatage(@PathParam("docum") String docum) throws IOException{
        crawler.saveToJson(articles, docum);
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
