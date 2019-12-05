<%@page import="crawlingScraping.Extractor,crawlingScraping.Article" contentType="text/html" pageEncoding="UTF-8"%>

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
            #elementContainer{
                text-align: justify;
            }
            #elementText{
                font-family: Verdana; 
                font-size: 14px; 
            }
            .separatorLine{
                border: 2px dashed black;
            }
            #title{
                text-align:center;
                font-family: Verdana;
            }
            
            #logo{
                position: absolute;
                right: 5%;
                top: 0%;
                height: 80px;
                width: 85px
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
            #text{
                font-family: Verdana;
                font-size: 16px;
                font-weight: bold;
                color: red;
                
            }
            #text_1{
                font-family: Verdana;
                font-size: 16px;
                font-weight: bold;
            }
            footer{
                position:fixed; 
                width: 100%; 
                bottom:0;
                left:0;
                text-align:center;
                background-color:#4CAF50;
            }
        </style>
    </head>
    
    <body>
        <img id="logo" src="img\logo.png">
        
        <h1 id="title">Extracted Article</h1>
        <br>
        <%  
        String url=request.getParameter("urli");
        Article art = Extractor.getArticle(url);
        %>
        <span id="text"><% out.write("Title:"); %></span>
        <span id="text_1"><% out.write(" " + art.getTitle()); %></span>
        <br><br>
        <span id="text"><% out.write("URL:"); %></span>
        <span id="text_1"><% out.write(" " + art.getUrl()); %></span>
        <br>
        <p id="elementContainer">
            <span id="elementText">
                <span id="text"><% out.write("Text:"); %></span>
                <br>
                <% out.write(art.getText()); %>
            </span>
        </p>
        
        <br>
        <footer>
            <div style="float:right;">
                <form action="index.html" autocomplete="off" >
                    <input  type="submit" id="bottone" value="HOME">
                </form>
            </div>
        </footer>
    </body>
</html>
