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
    //public static void main(String[] args) throws Exception {
        
        final int CRAWLER_MAX_DEPTH = Integer.parseInt(crawlerDepth);
        final int CRAWLERS_NUM = 1; // +++ aggiustare passaggio del numero di crawlers +++
        final String CRAWL_STORAGE = "/data/crawl/root";

        /*
         * Instantiate crawl config
         */
        CrawlConfig config = new CrawlConfig();
        config.setCrawlStorageFolder(CRAWL_STORAGE);
        config.setMaxDepthOfCrawling(CRAWLER_MAX_DEPTH);

        /*
         * Instantiate controller for this crawl.
         */
        PageFetcher pageFetcher = new PageFetcher(config);
        RobotstxtConfig robotstxtConfig = new RobotstxtConfig();
        RobotstxtServer robotstxtServer = new RobotstxtServer(robotstxtConfig, pageFetcher);
        CrawlController controller = new CrawlController(config, pageFetcher, robotstxtServer);


        /*
         * Add seed URLs
         */
        controller.addSeed(visionURL);

        /*
         * Start the crawl.
         */
        controller.start(TestCrawler.class, CRAWLERS_NUM);
        //NON SERVE QUESTA ROBA
        if(controller.isFinished())
            finished();
        boolean fin=killExecution();
        if(fin == true)
            controller.shutdown();
    }
    public ArrayList<String> readExtractedUrl() throws FileNotFoundException, IOException{
        /* LETTURA DA FILE DEI LINK OTTENUTI E SALVATI*/
        
        System.out.println("------------------- FILE TESTINA ----------------------------");
        
        FileReader f;
        f = new FileReader("testina.txt");
        BufferedReader b;
        b = new BufferedReader(f);
        String s;
        ArrayList<String> urli = new ArrayList();
        ArrayList<String> urli2 = new ArrayList();
       
        s=b.readLine();
        StringTokenizer st = new StringTokenizer (s);
        while (st.hasMoreTokens ()) {
        urli.add(st.nextToken());
        }
        
        /*Stampa dell'ArrayList*/
        for(int i=0; i<urli.size(); i++) {
            System.out.println(urli.get(i));
        }
        System.out.println("\n------------------- LISTA PULITA ----------------------------");
        for(String x : urli){
            String str2 = x.substring(0, x.length() - 1);
            urli2.add(str2);
        }
        for(String x : urli2){
            System.out.println(x);
        }
        return urli2;
    }
        /* DATA EXTRACTION DAGLI ARTICOLI DELLA LISTA*/
    public ArrayList<Article> extraction(ArrayList<String> x) throws Exception {
        ArrayList<Article> articles = new ArrayList();
        System.out.println("------------- LISTA DI ARTICOLI -------------");
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