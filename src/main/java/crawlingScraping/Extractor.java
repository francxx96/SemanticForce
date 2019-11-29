
package crawlingScraping;

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
import javax.ws.rs.Produces;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.MediaType;
import org.xml.sax.SAXException;
import utils.OutputHandler;

@Path("WebEstrazione")
public class Extractor {
    static App crawler;
    static ArrayList<String> extractedUrl = new ArrayList();
    static ArrayList<Article> articles = new ArrayList();    

    public Extractor() {
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
            System.out.println(ex);
        } catch (IOException | IllegalCharsetNameException ex) {
            System.out.println(ex);
            System.out.println("Cannot retrieve article from: " + url);
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
        
        System.out.println("---- URL LIST ----");
        extractedUrl = OutputHandler.readUrlsFile();
        System.out.println(extractedUrl.toString());
        
        return extractedUrl.toString();
    }
    
    /**
     * Function for data estraction of articles
     * 
     * @param nArticles
     * @return
     * @throws Exception 
     */
    @GET
    @Path("articolob")
    @Produces(MediaType.TEXT_HTML)
    public static ArrayList<Article> getExtractedArticles(int nArticles) throws Exception {
        int listLen = extractedUrl.size();
        
        if(listLen < nArticles)
            nArticles = listLen;
        
        System.out.println("---- Articles list ----");
        int addedArt = 0, j = 0;
        while(addedArt < nArticles && j < listLen) {
            String url = extractedUrl.get(j);
            Article art = getArticle(url);
            
            if(!art.getTitle().equals("=== WARNING! ===")) {
                articles.add(art);
                addedArt++;
            }
            
            j++;
        }
        
        System.out.println(articles);
        return articles;
    }
}
