/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package crawlingScraping;

import edu.uci.ics.crawler4j.crawler.CrawlConfig;
import edu.uci.ics.crawler4j.crawler.CrawlController;
import edu.uci.ics.crawler4j.fetcher.PageFetcher;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtConfig;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtServer;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.StringTokenizer;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import com.google.gson.Gson;

/**
 *
 * @author aless
 */
public class App {
    public App(String visionURL, String crawlerDepth) throws Exception {        
        final int CRAWLER_MAX_DEPTH = Integer.parseInt(crawlerDepth);
        final int CRAWLERS_NUM = 1; // +++ aggiustare passaggio del numero di crawlers +++
        final String CRAWL_STORAGE = "/data/crawl/root";
        
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
        
        /*
        //NON SERVE QUESTA ROBA
        if(controller.isFinished())
            finished();
        boolean fin=killExecution();
        if(fin == true)
            controller.shutdown();
        */
    }
    
    /**
     * Function that reads the extracted URLs from the stored file
     * 
     * @return
     * @throws FileNotFoundException
     * @throws IOException 
     */
    public ArrayList<String> readExtractedUrl() throws FileNotFoundException, IOException{
        FileReader f = new FileReader("testina.txt");
        BufferedReader buf = new BufferedReader(f);
        
        String bufferLine = buf.readLine();
        StringTokenizer tokenizer = new StringTokenizer(bufferLine, ",");
        
        ArrayList<String> urlList = new ArrayList();
        
        System.out.println("---- URL LIST ----");
        while (tokenizer.hasMoreTokens()) {
            String url = tokenizer.nextToken();
            urlList.add(url);
            System.out.println(url);
        }
        
        return urlList;
    }
    
    /**
     * Function for data estraction of articles
     * 
     * @param x
     * @return
     * @throws Exception 
     */
    public ArrayList<Article> extraction(ArrayList<String> x) throws Exception {
        ArrayList<Article> articles = new ArrayList();
        System.out.println("---- LISTA DI ARTICOLI ----");
        for(int j=8; j<14; j++) {
            articles.add(Extractor.getArticle(x.get(j)));
        }
        
        System.out.println(articles);
        return articles;
    }
    
    public void saveToJson(ArrayList<Article> y, String z) throws IOException{
        Gson gson = new Gson();     
        String userJson = gson.toJson(y);
        FileWriter w;
        w = new FileWriter("src\\main\\resources\\" + z);

        BufferedWriter u;
        u = new BufferedWriter(w);
        u.write(userJson);
        u.flush();
        u.close();
    }
    
    public boolean finished(){
        return true;
    }
    
    public boolean killExecution(){
        return true;
    }
}