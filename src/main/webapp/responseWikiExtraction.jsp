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
        <title>JSP Page</title>
    </head>
    <style>
        .myBox {
            border: groove;
            padding: 5px;
            font: 24px/36px sans-serif;
            width: 60%;
            height: 400px;
            overflow: scroll;
            background-color: #ffce99;
        }
        body{
            background-color:#80d4ff;
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
    </style>
    <body>
        <h1 style="text-align:center">Entità ottenute</h1>

        <%
            /*
            
            // Lettura del file json
            // Prendo la lista e tramite il parser la impacchetto nel jsonObject
            // Estraggo i campi che mi servono e usando la getwikidata faccio la ricerca sulla label
            // Ottengo la coppia (label,url) e genero la lista
            
            ArrayList<String[]> list = new ArrayList<String[]>();
            list = wikidata.executeGet(parameter);
            String[] option1 = {"we","https://www.wikipedia.org"};
            prova.add(0, option1);
            prova.add(1, option1);
            prova.add(2, option1);
            prova.add(3, option1);
             */

            //acquisizione articoli
            ArrayList<Article> articoli = OutputHandler.readArticlesFile();

            //acquisizione entità
            ArrayList<ArrayList<Entity>> entities = OutputHandler.readEntityArticlesFile();


        %>
        <div>
            <h1 id="title"> Articoli analizzati </h1>
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
                        currEntity = entityList.get(j);
                        //System.out.println("ENTITY name="+currEntity.getName()+"*\toffset="+currEntity.getPosition()+"\ttype="+currEntity.getType());
                        subText = docText.substring(i, currEntity.getStartPos()); // get another part of text before the new entity 
            %>
            <span style="color:black"><%out.write(subText);%></span>
            <a href="responseWikidata.jsp?entityWiki=<%out.write(currEntity.getName());%>"><%out.write(currEntity.getName());%></a>

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
                %>
                </body>
                </html>
