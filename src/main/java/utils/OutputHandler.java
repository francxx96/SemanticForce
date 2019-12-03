
package utils;

import com.google.gson.Gson;
import crawlingScraping.Article;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Set;
import ner.Entity;

public class OutputHandler {
    private static final String DIRECTORY = System.getProperty("user.home")  // user directory
                                            + File.separator + "SemanticProject";
    private static final String TXT_URLS = "URLs_list.txt";
    private static final String URLS_PATH  = DIRECTORY + File.separator + TXT_URLS;
    
    private static final String JSON_ARTICLES = "Articles_list.json";
    private static final String ARTICLES_PATH = DIRECTORY + File.separator + JSON_ARTICLES;
    
    private static final String JSON_ENTITIES = "Entities_list.json";
    private static final String ENTITIES_PATH = DIRECTORY + File.separator + JSON_ENTITIES;
    
    private static final String JSON_ENTITYART = "EntityArticles_list.json";
    private static final String ENTITYART_PATH = DIRECTORY + File.separator + JSON_ENTITYART;
    
    private static File urlsFile = new File(URLS_PATH);
    private static File articlesFile = new File(ARTICLES_PATH);
    private static File entitiesFile = new File(ENTITIES_PATH);
    private static File entityArticlesFile = new File(ENTITYART_PATH);
    
    public OutputHandler() {
    }
    
    public static ArrayList<String> readUrlsFile() {
        ArrayList<String> urlList = new ArrayList();
        
        try(BufferedReader br = new BufferedReader(new FileReader(urlsFile))) {
            String url = br.readLine();
            
            while(url != null) {
                urlList.add(url);
                url = br.readLine();
            }
        } catch(IOException e) {
            System.out.println(e);
        }
        
        return urlList;
    }
    
    public static void writeUrlsFile(Set<String> links) {
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(urlsFile))) {
            
            for(String link : links)
                bw.write(link + "\n");
        
        } catch (IOException e) {
            System.err.println(e);
        }
    }
    
    public static void deleteUrlsFile() {
        urlsFile.delete();
    }
    
    public static ArrayList<Article> readArticlesFile() {
        ArrayList<Article> articlesList = new ArrayList();
        Gson g = new Gson();
        
        try {
            Article[] articlesArray = g.fromJson(new FileReader(articlesFile), Article[].class);
            articlesList.addAll(Arrays.asList(articlesArray));
        
        } catch (FileNotFoundException e) {
            System.out.println(e);
        }

        return articlesList;
    }
    
    public static void writeArticlesFile(ArrayList<Article> articles) {
        Gson gson = new Gson();
        String data = gson.toJson(articles);
        
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(articlesFile))) {
            bw.write(data);
        
        } catch (IOException e) {
            System.err.println(e);
        }
    }
    
    public static void deleteArticlesFile() {
        articlesFile.delete();
    }
    
    public static ArrayList<Entity> readEntitiesFile() {
        ArrayList<Entity> entitiesList = new ArrayList();
        Gson g = new Gson();
        
        try {
            Entity[] entitiesArray = g.fromJson(new FileReader(entitiesFile), Entity[].class);
            entitiesList.addAll(Arrays.asList(entitiesArray));
        
        } catch (FileNotFoundException e) {
            System.out.println(e);
        }

        return entitiesList;
    }
    
    public static void writeEntitiesFile(ArrayList<Entity> entities) {
        Gson gson = new Gson();
        String data = gson.toJson(entities);
        
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(entitiesFile))) {
            bw.write(data);
        
        } catch (IOException e) {
            System.err.println(e);
        }
    }
        
    public static void deleteEntitiesFile() {
        entitiesFile.delete();
    }
    
    
    public static ArrayList<ArrayList<Entity>>  readEntityArticlesFile() {
        ArrayList<ArrayList<Entity>> entitiesList = new ArrayList();
        Gson g = new Gson();
        
        try {
            Entity[][] entitiesArray = g.fromJson(new FileReader(entityArticlesFile), Entity[][].class);
            for(int i=0; i<entitiesArray.length; i++){
                entitiesList.add(i, (ArrayList<Entity>) Arrays.asList(entitiesArray[i]));
            }   
        } catch (FileNotFoundException e) {
            System.out.println(e);
        }

        return entitiesList;
    }
    
    public static void writeEntityArticleFile(ArrayList<ArrayList<Entity>> entities) {
        Gson gson = new Gson();
        String data = gson.toJson(entities);
        
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(entityArticlesFile))) {
            bw.write(data);
        
        } catch (IOException e) {
            System.err.println(e);
        }
    }
    
    public static void deleteEntityArticlesFile() {
        entityArticlesFile.delete();
    }
}
