<%@page import="utils.OutputHandler"%>
<%@page import="crawlingScraping.Crawler"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.lang.Long"%>
<%@page import="crawlingScraping.Extractor" contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SemanticForce</title>
        <link rel="icon" href="img\logo.png" type="image/x-icon"/>
        <style>
            body{
                background-color:#00ffbf;
            }
            #logo{
                position: absolute;
                right: 5%;
                top: 0%;
                height: 80px;
                width: 85px
            }
            #crawlingInfo{
                text-align: center;
            }
            #crawlingElements{
                text-align: justify;
            }
            #errorContainer{
                text-align: center;
            }
            #elementText{
                font-family: Verdana; 
                font-size: 14px; 
            }
            #title{
                text-align:center;
                font-family: Verdana;
            }
            #text{
                font-family: Verdana;
                font-size: 16px;
                font-weight: bold;
                
            }
            #text_1{
                font-family: Verdana;
                font-size: 16px;     
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
            
        </style>
    </head>
    
    <body>
        <img id="logo" src="img\logo.png">
        <%  
        String url = request.getParameter("urla");
        String time = null;
        ArrayList<String> links = null;
        String linksNum = null;
        
        if(Crawler.shouldVisit(url)) {
            String depth = request.getParameter("Cprof");
            
            long startTime = System.currentTimeMillis();
            Crawler.start(url, depth);
            links = OutputHandler.readUrlsFile();
            
            long endTime = System.currentTimeMillis();
            long delta = endTime - startTime;
            time = Long.valueOf(delta).toString();
            
            linksNum = Integer.toString(links.size());
        %>
        
        <div id="crawlingInfo">
            <h1 id="title">Extracted URLs</h1>
        </div>
        <br><br>
        <span id="text"><% out.write("Execution time:"); %></span>
        <span id="text_1"><% out.write(" " + time); %></span>
        <br>
        <span id="text"><% out.write("N° of extracted URLs:"); %></span>
        <span id="text_1"><% out.write(" " + linksNum); %></span>
        <br><br> 
        <p id="crawlingElements">
            <span>
                <%
                for(String link : links) {
                %>
                
                <span id="elementText">
                    <% out.write("- " + link); %>
                </span>
                <br>
                
                <%
                }
                %>
            </span>
        </p>
        
        <%
        } else {
        %>
        
        <div id="errorContainer">
            <h1>URL NON VALIDO --- Tornare indietro</h1>
        </div>
        
        <%
        }
        %>
        
        <br>
        <div style="text-align:center;">
            <form action="index.html" autocomplete="off" >
                <input  type="submit" id="bottone" value="HOME">
            </form>
        </div>
    </body>
</html>
