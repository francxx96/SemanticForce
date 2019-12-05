/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import static crawlingScraping.Crawler.shouldVisit;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Utente
 */
public class CrawlerTest {
    // A classic page of the allowed domains set
    private final String validUrl1 = "https://www.thesun.co.uk/news/10464355/london-bridge-vigil-honour-victims/";
    // A classic page of the allowed domains set
    private final String validUrl2 = "https://www.dailymail.co.uk/news/article-7745745/Commuter-chaos-travel-misery-27-day-South-Western-Railway-strike-begins-today.html";
    // A page belonging to unallowed domains
    private final String invalidUrl1 = "https://www.facebook.com/";
    // A page of the allowed domains set, but referring to an image
    private final String invalidUrl2 = "https://www.thetimes.co.uk/imageserver/image/methode%2Ftimes%2Fprod%2Fweb%2Fbin%2Ff63c4ed4-1481-11ea-99d6-4e6452715c3d.jpg?crop=3494%2C1965%2C53%2C217&resize=685";
    
    public CrawlerTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    // TODO add test methods here.
    // The methods must be annotated with annotation @Test. For example:
    //
    // @Test
    // public void hello() {}
    
    @Test
    public void shouldVisitTest(){
        // The test should return true for the pages that should be visited,
        // false otherwise.
        assertTrue(shouldVisit(validUrl1));
        assertTrue(shouldVisit(validUrl2));
        assertFalse(shouldVisit(invalidUrl1));
        assertFalse(shouldVisit(invalidUrl2));
    }
}
