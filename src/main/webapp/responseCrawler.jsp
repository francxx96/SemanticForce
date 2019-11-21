<%-- 
    Document   : responseCrawler
    Created on : 25-set-2018, 10.52.50
    Author     : aless
--%>

<%@page import="java.util.StringTokenizer"%>
<%@page import="crawlingScraping.Article"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.lang.Long"%>
<%@page import="crawlingScraping.Extractor" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Extracted URLs</title>
        <link rel="icon" href="img\tabLogo.png" type="image/x-icon"/>
    </head>
    <body style="background-color:#CCFFCC">
        <%  String url=request.getParameter("urla");
            String prof = request.getParameter("Cprof");
            long f = System.currentTimeMillis();
            String links = Extractor.getXml(url, prof);
            String linkes = links;
            long g = System.currentTimeMillis();
            long x = g-f;
            String time = Long.valueOf(x).toString();
            int i = 0;
            
            StringTokenizer st = new StringTokenizer(linkes, ",");
            while(st.hasMoreTokens()){
                i++;
                linkes=st.nextToken();
            }
            String linknum = Integer.toString(i);
         %>
        <div style="text-align: center">
        <h1 Style="color:#006666">Extracted URLs</h1>
        <h3 Style="color:#006666"> Execution time: <%out.write(time);%>ms</h3>
        <h3 Style="color:#006666"> N° of extracted URLs: <%out.write(linknum);%></h3>
        </div>
        <p Style="text-align:justify">
        <span style="font-family: verdana; font-size: 10px; color: #000000"><%out.write(links);%></span>
        </p>
    </body>
</html>
