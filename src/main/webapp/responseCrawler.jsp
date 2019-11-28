<%@page import="java.util.regex.Pattern"%>
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
        <%  Pattern FILTERS = Pattern.compile(".*(\\.(css|js|gif|jpg|png|mp3|mp4|zip|gz))$");
            String url=request.getParameter("urla");
            String time = null;
            String linknum = null;
            String links = null;
            if(!FILTERS.matcher(url).matches()){
                String prof = request.getParameter("Cprof");
                long f = System.currentTimeMillis();
                links = Extractor.getXml(url, prof);
                String linkes = links;
                long g = System.currentTimeMillis();
                long x = g-f;
                time = Long.valueOf(x).toString();
                int i = 0;

                StringTokenizer st = new StringTokenizer(linkes, ",");
                while(st.hasMoreTokens()){
                    i++;
                    linkes=st.nextToken();
                }
                linknum = Integer.toString(i);
            %>
                <div id="crawlingInfo">
                <h1>Extracted URLs</h1>
                <h3> Execution time: <%out.write(time);%>ms</h3>
                <h3> N° of extracted URLs: <%out.write(linknum);%></h3>
                </div>
                <p id="crawlingElements">
                <span style="font-family: verdana; font-size: 10px; color: #000000"><%out.write(links);%></span>
                </p>
        <%
            }else{
         %>
                <div id="errorContainer">
                <h1>URL NON VALIDO --- Tornare indietro</h1>
                </div>
        <%}%>
    </body>
</html>
