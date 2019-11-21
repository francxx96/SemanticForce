<%-- 
    Document   : responseElSearch
    Created on : 27-set-2018, 15.17.55
    Author     : aless
--%>

<%@page import="crawlingScraping.Extractor" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Loading OK</title>
        <link rel="icon" href="img\tabLogo.png" type="image/x-icon"/>
    </head>
    <body style="background-color:#CCFFCC">
        <div style="text-align:center">
             <%
                String nomefile = request.getParameter("doco");
                String nomeindex = request.getParameter("doci");
                Extractor.elastic(nomeindex, nomefile);
             %>
            <div style="text-align: center">
            <h1 Style="color:#006666">Loading "<%out.write(nomeindex);%>" index successfully</h1>
            </div>
            <div style="text-align: center">
                <img src="https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2016/03/elastic_kibana-320x320.png" width="120" height="120">
                <br/>
                <a href="http://localhost:5601/app/kibana#/home?_g=()">View on Kibana</a>
            </div>
        </div>
    </body>
</html>
