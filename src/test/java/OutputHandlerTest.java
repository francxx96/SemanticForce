/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import crawlingScraping.Article;
import utils.OutputHandler;
import java.util.ArrayList;
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
public class OutputHandlerTest {
    private static ArrayList<Article> articles;
    
    public OutputHandlerTest() {
        
        
    }
    
    @BeforeClass
    public static void setUpClass() {
        articles = OutputHandler.readArticlesFile();
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
        articles = new ArrayList();
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
    public void readTest () {
        articles = OutputHandler.readArticlesFile();
        
        //for(Article art : articles)
            System.out.println(articles.toString());
    }
}
