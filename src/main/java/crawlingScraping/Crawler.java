
package crawlingScraping;

import edu.uci.ics.crawler4j.crawler.CrawlConfig;
import edu.uci.ics.crawler4j.crawler.CrawlController;
import edu.uci.ics.crawler4j.crawler.Page;
import edu.uci.ics.crawler4j.crawler.WebCrawler;
import edu.uci.ics.crawler4j.fetcher.PageFetcher;
import edu.uci.ics.crawler4j.parser.HtmlParseData;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtConfig;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtServer;
import edu.uci.ics.crawler4j.url.WebURL;
import java.io.File;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Pattern;
import utils.OutputHandler;

public class Crawler extends WebCrawler {
    private Set<String> allLinks = new HashSet();
    private final static Pattern FILTERS = Pattern.compile(".*(\\.(css|js|gif|jpg|png|mp3|mp4|zip|gz))$");
    
    public Crawler() {
    }
    
    public Crawler(String firstUrl, String crawlerDepth) throws Exception {
        
        final String CRAWL_STORAGE = System.getProperty("user.home")  // user directory
                                    + File.separator + "SemanticProject"
                                    + File.separator + "crawl"
                                    + File.separator + "root";
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
        this.allLinks.add(firstUrl);
        controller.addSeed(firstUrl);
        
        // Starts the crawler
        controller.start(Crawler.class, CRAWLERS_NUM);
    }
    
    /**
     * Specify whether the given url should be crawled or not based on
     * the crawling logic. Here URLs with extensions css, js etc will not be visited.
     * 
     * @param referringPage
     * @param url
     * @return true if the page should be visited
     */
    @Override
    public boolean shouldVisit(Page referringPage, WebURL url) {
        String href = url.getURL().toLowerCase();
        
        return !FILTERS.matcher(href).matches();
    }

    /**
     * This function is called when a page is fetched and ready
     * to be processed by the program.
     * 
     * @param page 
     */
    @Override
    public void visit(Page page) {
        WebURL webUrl = page.getWebURL();
        
        if(shouldVisit(page, webUrl)) {
            if(page.getParseData() instanceof HtmlParseData) {
                
                HtmlParseData htmlParseData = (HtmlParseData) page.getParseData();      
                String text = htmlParseData.getText(); //extract text from page
                String html = htmlParseData.getHtml(); //extract html from page
                Set<WebURL> outLinks = htmlParseData.getOutgoingUrls();
                
                for(WebURL link : outLinks)
                    if(shouldVisit(page, link))
                        allLinks.add(link.getURL());

                System.out.println("-------------------------------------");
                System.out.println("Page URL: " + webUrl.getURL());
                System.out.println("Text length: " + text.length());
                System.out.println("Html length: " + html.length());
                System.out.println("Number of outgoing links: " + outLinks.size());
                System.out.println("-------------------------------------");
                
                System.out.println("=== Saving URL list, size: " + allLinks.size() + " ...");
                OutputHandler.writeUrlsFile(allLinks);
                System.out.println("=== Saving complete!");
            }
        }
    }
}