/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package crawlingScraping;

import edu.uci.ics.crawler4j.crawler.Page;
import edu.uci.ics.crawler4j.crawler.WebCrawler;
import edu.uci.ics.crawler4j.parser.HtmlParseData;
import edu.uci.ics.crawler4j.url.WebURL;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Pattern;

/**
 *
 * @author aless
 */
public class TestCrawler extends WebCrawler {
    private Set<String> allLinks = new HashSet();    
    private final static Pattern FILTERS = Pattern.compile(".*(\\.(css|js|gif|jpg|png|mp3|mp4|zip|gz))$");

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
            allLinks.add(webUrl.getURL());
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
                
                Savatage(allLinks);
            }
        }
    }
    
    /*faccio salvare sul file perchè non ho possibilità di passare al main pur assegnando un tipo di ritorno alla funzione
    Nel main infatti viene invocato "TestCrawler.class" senza inizializare un oggetto del tipo TestCrawler*/
    public void Savatage(Set<String> links) {
        System.out.println("=== Saving URL list, size: " + links.size() + " ...");
        
        String directory = System.getProperty("user.home");
        System.out.println("=== File path: " + directory);
        String fileName = "output.txt";
        String absolutePath = directory + File.separator + fileName;

        // write the content in file 
        try(BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(absolutePath))) {
            for(String link : links)
                bufferedWriter.write(link + "\n");
            
        } catch (IOException e) {
            System.err.println(e);
        }
        
        System.out.println("=== Saving complete!");
        // System.out.println(links.toString());
    }
}