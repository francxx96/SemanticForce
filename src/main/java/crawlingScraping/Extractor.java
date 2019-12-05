
package crawlingScraping;

import de.l3s.boilerpipe.BoilerpipeProcessingException;
import de.l3s.boilerpipe.document.TextDocument;
import de.l3s.boilerpipe.extractors.CommonExtractors;
import de.l3s.boilerpipe.sax.BoilerpipeSAXInput;
import de.l3s.boilerpipe.sax.HTMLDocument;
import de.l3s.boilerpipe.sax.HTMLFetcher;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import javax.ws.rs.Produces;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.MediaType;
import org.xml.sax.SAXException;
import utils.OutputHandler;

@Path("WebEstrazione")
public class Extractor {   

    public Extractor() {
    }
    
    @GET
    @Path("articoloa/{url}")
    @Produces(MediaType.APPLICATION_JSON)
    public static Article getArticle(String url) {
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
            
        } catch (IOException | SAXException | BoilerpipeProcessingException ex) {
            System.out.println(ex);
            article.setTitle("=== WARNING! ===");
            article.setText("This page cannot be displayed here!");
            
        } 
        
        return article;
    }
    
    /**
     * Function for data estraction of articles
     * 
     * @param nArticles
     * @return 
     */
    @GET
    @Path("articolob")
    @Produces(MediaType.TEXT_HTML)
    public static ArrayList<Article> getExtractedArticles(int nArticles){
        ArrayList<Article> articles = new ArrayList();
        ArrayList<String> extractedUrls= OutputHandler.readUrlsFile();
        int listLen = extractedUrls.size();
        
        if(listLen < nArticles)
            nArticles = listLen;
        
        int addedArt = 0, j = 0;
        while(addedArt < nArticles && j < listLen) {
            String url = extractedUrls.get(j);
            Article art = getArticle(url);
            
            if(!art.getTitle().equals("=== WARNING! ===")) {
                articles.add(art);
                addedArt++;
            }
            
            j++;
        }
        
        System.out.println("=== Articles list: ");
        System.out.println(articles);
        
        return articles;
    }
}
