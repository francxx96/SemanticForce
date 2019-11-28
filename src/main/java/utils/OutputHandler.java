/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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

/**
 *
 * @author Utente
 */
public class OutputHandler {
    private static final String DIRECTORY = System.getProperty("user.home");
    private static final String TXT_URLS = "URLs_list.txt";
    private static final String URLS_PATH  = DIRECTORY + File.separator + TXT_URLS;;
    private static final String JSON_ARTICLES = "Articles_list.json";
    private static final String ARTICLES_PATH = DIRECTORY + File.separator + JSON_ARTICLES;
    private static final String JSON_ENTITIES = "Entities_list.json";
    private static final String ENTITIES_PATH = DIRECTORY + File.separator + JSON_ENTITIES;

    public OutputHandler() {
    }
    
    public static ArrayList<String> readUrlsFile() {
        ArrayList<String> urlList = new ArrayList();
        
        try(BufferedReader br = new BufferedReader(new FileReader(URLS_PATH))) {
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
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(URLS_PATH))) {
            
            for(String link : links)
                bw.write(link + "\n");
        
        } catch (IOException e) {
            System.err.println(e);
        }
    }
    
    public static ArrayList<Article> readArticlesFile() {
        ArrayList<Article> articlesList = new ArrayList();
        Gson g = new Gson();
        
        try {
            Article[] articlesArray = g.fromJson(new FileReader(ARTICLES_PATH), Article[].class);
            articlesList.addAll(Arrays.asList(articlesArray));
        
        } catch (FileNotFoundException e) {
            System.out.println(e);
        }

        return articlesList;
    }
    
    public static void writeArticlesFile(ArrayList<Article> articles) {
        Gson gson = new Gson();
        String data = gson.toJson(articles);
        
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(ARTICLES_PATH))) {
            bw.write(data);
        
        } catch (IOException e) {
            System.err.println(e);
        }
    }
    
    public static ArrayList<Entity> readEntitiesFile() {
        ArrayList<Entity> entitiesList = new ArrayList();
        Gson g = new Gson();
        
        try {
            Entity[] entitiesArray = g.fromJson(new FileReader(ARTICLES_PATH), Entity[].class);
            entitiesList.addAll(Arrays.asList(entitiesArray));
        
        } catch (FileNotFoundException e) {
            System.out.println(e);
        }

        return entitiesList;
    }
    
    public static void writeEntitiesFile(ArrayList<Entity> entities) {
        Gson gson = new Gson();
        String data = gson.toJson(entities);
        
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(ENTITIES_PATH))) {
            bw.write(data);
        
        } catch (IOException e) {
            System.err.println(e);
        }
    }
}
