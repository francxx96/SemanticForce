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
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import com.google.gson.Gson;
import java.io.File;

/**
 *
 * @author aless
 */
public class App {
    private final String directory;
    private final String txtFile;
    private final String txtAbsPath;
    
    public App(String visionURL, String crawlerDepth) throws Exception {   
        this.directory = System.getProperty("user.home");
        
        this.txtFile = "output.txt";
        this.txtAbsPath = directory + File.separator + txtFile;
        
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
        
        /* NON SERVE QUESTA ROBA
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
     */
    public ArrayList<String> readExtractedUrl() {
        ArrayList<String> urlList = new ArrayList();
        
        System.out.println("---- URL LIST ----");
        try(BufferedReader bufferedReader = new BufferedReader(new FileReader(txtAbsPath))) {
            String url = bufferedReader.readLine();
            while(url != null) {
                urlList.add(url);
                System.out.println(url);
                url = bufferedReader.readLine();
            }
        } catch (FileNotFoundException e) {
            System.out.println(e);
        } catch (IOException e) {
            System.out.println(e);
        }
        
        return urlList;
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
        if(x.size()<nArticles)
            nArticles = x.size();
        System.out.println("---- Articles list ----");
        int i=0, j;
        j=i;
        for(i=0;i<nArticles;i++) {
            Article art = Extractor.getArticle(x.get(j));
            if(art.getTitle().equals("=== WARNING! ===")){
                j++;
                i--;
            }
            else{
                articles.add(art);
                j++;
            }
            
            /*Domanda per ciccio, vogliamo visualizzare in ogni caso il numero di articoli richesti dall'utente?*/
        }
        
        System.out.println(articles);
        return articles;
    }
    
    public void saveToJson(ArrayList<Article> y, String z) throws IOException{
        Gson gson = new Gson();     
        String userJson = gson.toJson(y);
        FileWriter w;
        w = new FileWriter(z);

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