<%-- 
    Document   : wikidataInformation
    Created on : 26-nov-2019, 17.59.51
    Author     : Michele
--%>

<%@page import="crawlingScraping.Article"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utils.OutputHandler"%>
<%@page import="ner.Entity"%>
<%@page import="wikidata.wikidata" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SemanticForce</title>
        <link rel="icon" href="img\logo.png" type="image/x-icon"/>
    </head>
    <style>
        .myBox {
            border: groove;
            padding: 5px;
            font: 24px/36px Verdana;
            width: 60%;
            height: 400px;
            overflow: scroll;
            background-color: #00ffbf;
        }
        body{
            background-color:#00ffbf;
        }

        /* Scrollbar styles */
        ::-webkit-scrollbar {
            width: 12px;
            height: 12px;
        }

        ::-webkit-scrollbar-track {
            background: #f5f5f5;
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            border-radius: 10px;
            background: #ccc;  
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #999;  
        }
        #bottone{
                outline: none;
                cursor: pointer;
                text-align: center;
                text-decoration: none;
                font: bold 12px Arial, Helvetica, sans-serif;
                color: #fff;
                padding: 10px 20px;
                border: solid 1px #16a085;
                background: #1abc9c;
                -moz-border-radius: 20px;
                -webkit-border-radius: 20px;
                border-radius: 20px;
            }
            #bottone:hover { 
                background: #109177;
            }  
            #logo{
                position: absolute;
                right: 5%;
                top: 0%;
                height: 80px;
                width: 85px
            }
            #title{
                text-align:center;
                font-family: Verdana;
            }
            
    </style>
    <body>
        <img id="logo" src="img\logo.png">
        <h1 id="title">Search entities</h1>
        <br>
        <%
            
            //acquisizione articoli
            ArrayList<Article> articoli = OutputHandler.readArticlesFile();

            //acquisizione entità
            ArrayList<ArrayList<Entity>> entities = OutputHandler.readEntityArticlesFile();


        %>
        <div>
            <%     for (int l = 0; l < articoli.size(); l++) {
                    
                    // ottengo le entità dell'articolo corrente
                    ArrayList<Entity> entityList = entities.get(l);
                    
                    // ottengo le informaizoni dell'articolo corrente
                    String docText = articoli.get(l).getText();
                    String title = articoli.get(l).getTitle();

                    Entity currEntity;
                    String subText;
                    int i = 0, j = 0;
            %>
            <h2 style="color:black"> <%out.write(title);%> </h2>
            <br>
            <%
                while (i < docText.length()) {
                    
                    // dentro al testo
                
                    if (j < entityList.size()) {
                        // prendo l'entità
                        currEntity = entityList.get(j);
                        
                        String keyWords="";
                        
                        for(String elem: currEntity.getKeyWords()){
                            keyWords = keyWords + elem + "%2C"; 
                        }
                        
                        // setto la stringa rappresentante le parole chiave
                        currEntity.setkWords(keyWords);
                        
                                             
                        // effettuo il refactor della lista di entità
                        entityList.set(j, currEntity);
                        
                        subText = docText.substring(i, currEntity.getStartPos()); 
            %>
            <span style="color:black"><%out.write(subText);%></span>
            <a href="responseWikidata.jsp?entityWiki=<%out.write(currEntity.getName());%>&keyWords=<%out.write(keyWords);%>"><%out.write(currEntity.getName());%></a>

               <%

                   i = currEntity.getEndPos();
                   j++;

               } else {
                   subText = docText.substring(i);
               %>
               <span style="color:black"><%out.write(subText);%></span>
                <%
                            i = docText.length();
                        }
                    }


                %>
                <br><br><br>
                <hr class="separatorLine">               
                <%            }
                OutputHandler.writeEntityArticleFile(entities);
                %>
                
                </body>
                </html>
