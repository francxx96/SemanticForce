<%-- 
    Document   : responseExtraction
    Created on : 26-set-2018, 18.55.55
    Author     : aless
--%>

<%@page import="crawlingScraping.Extractor,java.util.ArrayList,crawlingScraping.Article" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Extracted Articles</title>
        <link rel="icon" href="img\tabLogo.png" type="image/x-icon"/>
        <style type="text/css">
            fieldset{
                border-style: dashed;
                border-color: #006666;
            }
            .bottone{
                background-color: #33CC66;
                border: ridge;
                color: white;
                font-weight: lighter;
                border-radius: 5px;
                
            }
            .bottone:hover{
                background-color: #336666;
            }
        </style>
    </head>
    <body style="background-color:#CCFFCC">
        <div Style="text-align:center">
            <h1 Style="color:#006666">Articles extracted from the URLs</h1>
        </div>
        <p Style="text-align:justify">
            <%  
                String url=request.getParameter("urle");
                String profa = request.getParameter("Cprofa");
                String links = Extractor.getXml(url,profa);
                String nArticles = request.getParameter("nArticles");
                int numArticles = Integer.parseInt(nArticles);
                ArrayList<Article> arti = Extractor.getExtractedArticles(numArticles);
            %>
            <span>
                <%
                    for(Article x : arti){
                %>
                    <h2 style="font-family: verdana;"><%out.write("TITOLO: "+x.getTitle());%></h2>
                    <h3 style="font-family: verdana;"><%out.write("URL: "+x.getUrl());%></h3>
                    <pre><span style="font-family: verdana; font-size: 10px; color: #000000"><%out.write("TESTO ARTICOLO: "+x.getText()+"\n");%></span></pre>
                <%  }
                %>
             </span>
        </p>
        <div style="text-align: center">
            <fieldset>
                <legend><h3 style="color:#006666">Save content in JSON</h3></legend>
                <form method="get" action="responseJSONSavatage.jsp">
                    <tr><td><label><h3 style="color:#006666">Filename</h3></label></td><td><input name="doca" type="text" ></td></tr>
                    <input class="bottone" type="submit" value="GO!">
                </form>
            </fieldset>
        </div>
    </body>
    
</html>
