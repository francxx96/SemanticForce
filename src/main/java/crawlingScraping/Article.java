/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package crawlingScraping;

/**
 *
 * @author aless
 */
public class Article {

    public String title;
    public String text;
    public String url;

    public Article() {
        this.title = "=== WARNING! ===";
        this.text = "This page cannot be displayed here!";
        this.url = "";
    }
    
    public Article(String title, String text, String url) {
        this.title = title;
        this.text = text;
        this.url = url;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @Override
    public String toString() {
        return "\nURL: " + url + "\nTitle: " + title + "\nText:\n " + text + "\n";
    }
}
