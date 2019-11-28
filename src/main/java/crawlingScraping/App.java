
package crawlingScraping;

import edu.uci.ics.crawler4j.crawler.CrawlConfig;
import edu.uci.ics.crawler4j.crawler.CrawlController;
import edu.uci.ics.crawler4j.fetcher.PageFetcher;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtConfig;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtServer;
import java.util.ArrayList;

public class App {
    
    public App(String visionURL, String crawlerDepth) throws Exception {   
        final String CRAWL_STORAGE = "/data/crawl/root";
        final int CRAWLER_MAX_DEPTH = Integer.parseInt(crawlerDepth);
        final int CRAWLERS_NUM = 1; // +++ aggiustare passaggio del numero di crawlers +++
        
        // Instantiate crawler config
        CrawlConfig config = new CrawlConfig();
        config.setCrawlStorageFolder(CRAWL_STORAGE);
        config.setMaxDepthOfCrawling(CRAWLER_MAX_DEPTH);
        
        // Instantiate controller for this crawler
        PageFetcher pageFetcher = new PageFetcher(config);
        RobotstxtConfig robotstxtConfig = new RobotstxtConfig();
        RobotstxtServer robotstxtServer = new RobotstxtServer(robotstxtConfig, pageFetcher);
        CrawlController controller = new CrawlController(config, pageFetcher, robotstxtServer);
        
        // Add seed URLs
        controller.addSeed(visionURL);
        
        // Starts the crawler
        controller.start(TestCrawler.class, CRAWLERS_NUM);
    }
    
    /**
     * Function for data estraction of articles
     * 
     * @param x
     * @param nArticles
     * @return
     * @throws Exception 
     */
    public ArrayList<Article> extraction(ArrayList<String> x, int nArticles) throws Exception {
        ArrayList<Article> articles = new ArrayList();
        
        int listLen = x.size();
        if(listLen < nArticles)
            nArticles = listLen;
        
        System.out.println("---- Articles list ----");
        int addedArt = 0, j = 0;
        while(addedArt < nArticles && j < listLen) {
            String url = x.get(j);
            Article art = Extractor.getArticle(url);
            
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