
<%@page import="crawlingScraping.Crawler"%>
<%@page import="utils.OutputHandler"%>
<%@page import="crawlingScraping.Extractor"%>
<%@page import="java.util.ArrayList"%>
<%@page import="crawlingScraping.Article"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>SemanticForce</title>
        <link rel="icon" href="img\logo.png" type="image/x-icon"/>
        <style type="text/css">
            body{
                background-color:#00ffbf;
            }
            #elementContainer{
                text-align: justify;
            }
            #articlesSection{
                text-align:justify;   
            }
            #titleStyle{}
            #URLStyle{}
            #textStyle{
                font-family: verdana; 
                font-size: 10px;
            }
            footer{
                position:fixed; 
                width: 100%; 
                bottom:0;
                left:0;
                text-align:center;
                background-color:#4CAF50;
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
            #elementText{
                font-family: Verdana; 
                font-size: 14px; 
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
        </style>
    </head>
    
    <body>
        <img id="logo" src="img\logo.png">
        <h1 id="title">Extracted Articles</h1>
        <br>
        <p id="articleSection">
            <%  
            String url = request.getParameter("urle");
            String depth = request.getParameter("Cprofa");
            Crawler.start(url, depth);
            String nArticles = request.getParameter("nArticles");
            int numArticles = Integer.parseInt(nArticles);
            ArrayList<Article> articles = Extractor.getExtractedArticles(numArticles);
            OutputHandler.writeArticlesFile(articles);
            System.out.println("responseExtractionArticle file saved");
            %>
            
        
        <div>
                <%
                for(Article art : articles) {
                    %>
                    <span id="text"><% out.write("Title:"); %></span>
                    <span id="text_1"><% out.write(" " + art.getTitle()); %></span>
                    <br><br>
                    <span id="text"><% out.write("URL:"); %></span>
                    <span id="text_1"><% out.write(" " + art.getUrl()); %></span>
                    <p id="elementContainer">
                        <span id="elementText">
                            <span id="text"><% out.write("Text:"); %></span>
                            <br>
                            <% out.write(art.getText()); %>
                        </span>
                    </p>
                    <hr class="separatorLine" />    
                    <%
                }
                %>
        </div>
     
        </p>
        <footer>
            <div style="float:right;">
                <form method="GET" action="responseEntityExtraction.jsp">
                    <input  type="submit" id="bottone" value="GO TO NER!">
                </form>
            </div>
        </footer>
    </body>
</html>
