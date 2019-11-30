<%@page import="utils.OutputHandler"%>
<%@page import="crawlingScraping.Crawler"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.lang.Long"%>
<%@page import="crawlingScraping.Extractor" contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Extracted URLs</title>
        <link rel="icon" href="img\tabLogo.png" type="image/x-icon"/>
        <style>
            body{
                background-color:#00ffbf;
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
        </style>
    </head>
    
    <body>
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
            <h1>Extracted URLs</h1>
            <h3>Execution time: <% out.write(time); %>ms</h3>
            <h3>N° of extracted URLs: <% out.write(linksNum); %></h3>
        </div>
        <p id="crawlingElements">
            <span>
                <%
                for(String link : links) {
                %>
                
                <span style="font-family: verdana; font-size: 10px; color: #000000">
                    <% out.write(link + "\n"); %>
                </span>
                
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
    </body>
</html>
