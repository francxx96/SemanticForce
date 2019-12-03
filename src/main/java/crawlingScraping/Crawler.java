
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
    private static Set<String> allLinks = new HashSet();
    private static final Pattern FILTERS = Pattern.compile(".*(\\.(css|js|gif|jpg|png|mp3|mp4|zip|gz))$");
    private static final Pattern FILTERSURL = Pattern.compile("^(https?:\\/\\/)?(www){1}\\.(thetimes|theguardian|independent|standard|thesun|express|dailymail|mirror|metro)\\.([a-z\\.]{2,6})([\\/\\w \\.-])\\/?");
    
    
    private static final String CRAWL_STORAGE = System.getProperty("user.home")  // user directory
                                                + File.separator + "SemanticProject"
                                                + File.separator + "crawl"
                                                + File.separator + "root";
    
    public Crawler() {   
    }
    
    public static void start(String firstUrl, String crawlerDepth) throws Exception {
        final int CRAWLER_MAX_DEPTH = Integer.parseInt(crawlerDepth);
        final int CRAWLERS_NUM = 1; // +++ aggiustare passaggio del numero di crawlers +++
        
        // Instantiates crawler config
        CrawlConfig config = new CrawlConfig();
        config.setCrawlStorageFolder(CRAWL_STORAGE);
        config.setMaxDepthOfCrawling(CRAWLER_MAX_DEPTH);
        
        // Instantiates controller for this crawler
        PageFetcher pageFetcher = new PageFetcher(config);
        RobotstxtConfig robotstxtConfig = new RobotstxtConfig();
        RobotstxtServer robotstxtServer = new RobotstxtServer(robotstxtConfig, pageFetcher);
        CrawlController controller = new CrawlController(config, pageFetcher, robotstxtServer);
        
        // Deletes the output file
        OutputHandler.deleteUrlsFile();
        
        // Adds seed URLs
        allLinks.add(firstUrl);
        controller.addSeed(firstUrl);
        
        // Starts the crawler
        controller.start(Crawler.class, CRAWLERS_NUM);

        System.out.println("=== URLs list: " + allLinks.toString());
        // Saves URLs in the output file
        System.out.println("=== Saving URLs list, size: " + allLinks.size() + " ...");
        OutputHandler.writeUrlsFile(allLinks);
        System.out.println("=== Saving complete!");
    }
    /**
     * Specify whether the given url should be crawled or not based on
     * the crawling logic. Here URLs with extensions css, js etc will not be visited.
     * 
     * @param url
     * @return true if the page should be visited
     */
    public static boolean shouldVisit(String url) {
        String href = url.toLowerCase();
        /*
        System.out.println("=== URL === " + url);
        System.out.println("=== VALIDATE EXTENCTION === " + !FILTERS.matcher(href).matches());
        System.out.println("=== VALIDATE PAGE === " + FILTERSURL.matcher(href).matches());
        System.out.println("=== REGEX === " + FILTERSURL);
        System.out.println("=== FINAL === " + (!FILTERS.matcher(href).matches() && FILTERSURL.matcher(href).find()));
        */
        return (!FILTERS.matcher(href).matches() && FILTERSURL.matcher(href).find());
    }

    /**
     * This function is called when a page is fetched and ready
     * to be processed by the program.
     * 
     * @param page 
     */
    @Override
    public void visit(Page page) {
        String url = page.getWebURL().getURL();
        
        if(shouldVisit(url)) {
            if(page.getParseData() instanceof HtmlParseData) {
                
                HtmlParseData htmlParseData = (HtmlParseData) page.getParseData();      
                String text = htmlParseData.getText(); //extract text from page
                String html = htmlParseData.getHtml(); //extract html from page
                Set<WebURL> outLinks = htmlParseData.getOutgoingUrls();
                
                for(WebURL link : outLinks)
                    if(shouldVisit(link.getURL()))
                        allLinks.add(link.getURL());
                
                System.out.println("-------------------------------------");
                System.out.println("Page URL: " + url);
                System.out.println("Page outgoing links number: " + outLinks.size());
                System.out.println("Total valid outgoing links: " + allLinks.size());
                System.out.println("-------------------------------------"); 
            }
        }
    }
}