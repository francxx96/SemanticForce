<%-- 
    Document   : wikiArticles
    Created on : 3-dic-2019, 11.10.30
    Author     : Michele
--%>

<%@page import="utils.OutputHandler"%>
<%@page import="crawlingScraping.Article"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>List of Articles</h1>
        <%
            ArrayList<Article> articles = OutputHandler.readArticlesFile();
        %>
        <span>
            <%
                for (Article art : articles) {
            %>
            <form method="POST" action="wikidataInformation.jsp">
                
                <input type="submit"  value=<% out.write("TITOLO: " + art.getTitle()); %> > 
            </form>
            <h2><a href="wikidataInformation.jsp" ><% out.write("TITOLO: " + art.getTitle()); %></a>  </h2> <%
                }
            %>
        </span>
    </body>
</html>
