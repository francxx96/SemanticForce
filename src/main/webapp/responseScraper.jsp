<%@page import="crawlingScraping.Extractor,crawlingScraping.Article" contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Extracted Article</title>
        <link rel="icon" href="img\tabLogo.png" type="image/x-icon"/>
        <style>
            body{
                background-color:#00ffbf;
            }
            #infoContainer{
                text-align: center;
            }
            #elementContainer{
                text-align: justify;
            }
            #elementText{
                font-family: verdana; 
                font-size: 12px; 
            }
            .separatorLine{
                border: 2px dashed black;
            }
        </style>
    </head>
    
    <body>
        <%  
        String url=request.getParameter("urli");
        Article art = Extractor.getArticle(url);
        %>
        
        <div id="infoContainer">
            <h2><%out.write(art.getTitle());%></h2>
            <h3><%out.write(art.getUrl());%></h3>
            <hr class="separatorLine">
        </div>
        <p id="elementContainer">
            <span id="elementText">
                <% out.write(art.getText()); %>
            </span>
        </p>
    </body>
</html>
