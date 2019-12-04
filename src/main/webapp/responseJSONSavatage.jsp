<%-- 
    Document   : responseJSONSavatage
    Created on : 27-set-2018, 10.17.37
    Author     : aless
--%>

<%@page import="crawlingScraping.Extractor" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Saving</title>
        <style>
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
        <%
            String docc=request.getParameter("doca");
            Extractor.getJSONSavatage(docc);
        %>
        <div style="text-align: center">
            <h1 Style="color:#006666">Articles saved correctly in "<%out.write(docc);%>"</h1>
        </div>
        <div style="text-align: center">
            <fieldset>
                <legend>Upload data to Elasticsearch</legend>
                <form method="get" action="responseElSearch.jsp">
                    <tr><td><label><h3>Filename</h3></label></td><td><input name="doco" type="text" value="<%out.write(docc);%>" readonly="readonly"></td></tr>
                    <tr><td><label><h3>Indexname</h3></label></td><td><input name="doci" type="text" ></td></tr>
                    <input class="bottone" type="submit" value="GO!">
                </form>
            </fieldset>
        </div>
    </body>
</html>
