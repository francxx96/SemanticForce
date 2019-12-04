<%-- 
    Document   : wikidataInformation
    Created on : 26-nov-2019, 17.59.51
    Author     : Michele
--%>

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
            
            // lettura del file json contenente le entità 
            ArrayList<Entity> entities = new ArrayList ();
            entities = OutputHandler.readEntitiesFile();
            
            
          
        %>
         <div class="myBox">
        <div id="list">
            <%
                for(Entity ent : entities){
                    
                
            %>
            
                <p><a href=<%out.write(ent.getName());%>> <%out.write(elem[0]);%></a></p>
                <%
                }
            
            %>
        </div>
        </div>
    </body>
</html>
    