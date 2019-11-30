
<%@page import="crawlingScraping.Crawler"%>
<%@page import="utils.OutputHandler"%>
<%@page import="crawlingScraping.Extractor,java.util.ArrayList,crawlingScraping.Article" contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Extracted Articles</title>
        <link rel="icon" href="img\tabLogo.png" type="image/x-icon"/>
        <style type="text/css">
            body{
                background-color:#00ffbf;
            }
            .heading_section{
                text-align: center;
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
            .footerSection{
                text-align: center;
            }
            .separatorLine{
                border: 2px dashed black;
            }
        </style>
    </head>
    
    <body>
        <div class="heading_section">
            <h1>Articles extracted from the URLs</h1>
        </div>
        <p id="articleSection">
            <%  
            String url = request.getParameter("urle");
            String depth = request.getParameter("Cprofa");
            Crawler.start(url, depth);
            String nArticles = request.getParameter("nArticles");
            int numArticles = Integer.parseInt(nArticles);
            ArrayList<Article> articles = Extractor.getExtractedArticles(numArticles);
            OutputHandler.writeArticlesFile(articles);
            %>
            <span>
                <%
                for(Article art : articles) {
                %>
                
                <h2><% out.write("TITOLO: " + art.getTitle()); %></h2>
                <h3><%out.write("URL: " + art.getUrl()); %></h3>
                <pre>
                    <span id="textStyle">
                        <% out.write("TESTO ARTICOLO: " + art.getText() + "\n"); %>
                    </span>
                </pre>
                <hr class="separatorLine">
                <%
                }
                %>
            </span>
        </p>
        <div class="footerSection">
            <h3>Go to NER</h3>
            <form method="GET" action="responseEntityExtraction.jsp">
                <input class="bottone" type="submit" value="GO!">
            </form>
        </div>
    </body>
</html>
