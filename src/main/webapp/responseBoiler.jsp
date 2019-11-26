<%-- 
    Document   : responseBoiler
    Created on : 25-set-2018, 10.48.13
    Author     : aless
--%>

<%@page import="crawlingScraping.Extractor,crawlingScraping.Article" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Extracted Article</title>
        <link rel="icon" href="img\tabLogo.png" type="image/x-icon"/>
    </head>
    <body style="background-color:#CCFFCC" >
        <%  String url=request.getParameter("urli");
            Article articolo = Extractor.getArticle(url);
        %>
        <div Style="text-align:center">
            <h2 Style="color:#006666"><%out.write(articolo.getTitle());%></h2>
            <h3 Style="color:#006666"><%out.write(articolo.getUrl());%></h3>
        </div>
        <p Style="text-align:justify">
        <span style="font-family: verdana; font-size: 12px; color: #000000"><%out.write(articolo.getText());%></span>
        </p>
    </body>
</html>
