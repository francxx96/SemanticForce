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
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;


/**
 *
 * @author aless
 */
public class TestCrawler extends WebCrawler{
    public static ArrayList<String> cmd =new ArrayList();
    
    private final static Pattern FILTERS = Pattern.compile(".*(\\.(css|js|gif|jpg|png|mp3|mp4|zip|gz))$");

    /**
     * Specify whether the given url should be crawled or not based on
     * the crawling logic. Here URLs with extensions css, js etc will not be visited
     */
    @Override
    public boolean shouldVisit(Page referringPage, WebURL url) {
        System.out.println("shouldVisit: " + url.getURL().toLowerCase());

        String href = url.getURL().toLowerCase();
        boolean result = !FILTERS.matcher(href).matches();

        if(result)
            System.out.println("URL Should Visit");
        else
            System.out.println("URL Should not Visit");

        return result;
    }

    /**
     * This function is called when a page is fetched and ready
     * to be processed by the program.
     */
    @Override
    public void visit(Page page) {
        String url = page.getWebURL().getURL();
        System.out.println("URL: " + url);
        
        if (page.getParseData() instanceof HtmlParseData) {
            ArrayList<String> linki = new ArrayList();
            HtmlParseData htmlParseData = (HtmlParseData) page.getParseData();      
            String text = htmlParseData.getText(); //extract text from page
            String html = htmlParseData.getHtml(); //extract html from page
            Set<WebURL> links = htmlParseData.getOutgoingUrls();

            System.out.println("---------------------------------------------------------");
            System.out.println("Page URL: " + url);
            System.out.println("Text length: " + text.length());
            System.out.println("Html length: " + html.length());
            for(WebURL w : links){
                System.out.println(w.toString());
                linki.add(w.toString());
            }
            
            System.out.println("Number of outgoing links: " + links.size());
            System.out.println("---------------------------------------------------------");

            //if required write content to file
            
            System.out.println("----------------SALVATAGGIO------------------");
            try {
                Savatage(linki);
            } catch (IOException ex) {
                Logger.getLogger(TestCrawler.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
}
    /*faccio salvare sul file perchè non ho possibilità di passare al main pur assegnando un tipo di ritorno alla funzione
    Nel main infatti viene invocato "TestCrawler.class" senza inizializare un oggetto del tipo TestCrawler*/
    public void Savatage(ArrayList<String> x) throws IOException{
        cmd.addAll(x);
        System.out.println("--------------NUOVA LISTA--------------\n"+cmd.size());
        System.out.println(cmd.toString());
        FileWriter w=new FileWriter("testina.txt");
        BufferedWriter bw=new BufferedWriter (w);
        bw.write(cmd.toString());
        bw.flush();
        bw.close();
    }
}