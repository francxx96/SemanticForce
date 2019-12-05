
<%@page import="wikidata.wikidata"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Wikidata Response</title>
        <style>
            .myBox {
                border: groove;
                padding: 5px;
                font: 24px/36px sans-serif;
                width: 90%;
                height: 600px;
                overflow: scroll;
                background-color: #ffff80;
                margin-left: auto;
                margin-right: auto;
            }
            body{
                background-color:#00ccff;
            }

            /* Scrollbar styles */
            ::-webkit-scrollbar {
                width: 12px;
                height: 12px;
            }

            ::-webkit-scrollbar-track {
                background: #f5f5f5;
                border-radius: 10px;
            }

            ::-webkit-scrollbar-thumb {
                border-radius: 10px;
                background: #ccc;  
            }

            ::-webkit-scrollbar-thumb:hover {
                background: #999;  
            }

            .headerCell{
                display:table-cell;
                font-family:sans-serif;
                text-align: left;
                width:200px;
                padding-left: 5px;
                vertical-align: top;
            }
        </style>
    </head>

    <body>
        <%
            // questo è il parametro che vi passa l'input nella pagina precedente
            request.setCharacterEncoding("UTF-8");
            String parameter = request.getParameter("entityWiki");
            System.out.println("enity for wikidata = " + parameter);

            ArrayList<String[]> list = new ArrayList();
            list = wikidata.executeGet(parameter);


        %>
        <div>
            <h1 style="text-align: center; font-family:sans-serif;">Research executed</h1>
        </div>
        <div class="myBox">
            <table>
                <thead>
                    <tr>
                        <th class="headerCell">Searched entity</th>
                        <th class="headerCell">Entities found</th>
                        <th class="headerCell">Description</th>
                    </tr>
                </thead>
                <tbody>
                    <%                for (String[] elem : list) {

                    %>
                    <tr>
                        <th style="text-align: left; padding-left: 5px"><% out.write(parameter);%></th>

                        <td><a href=<%out.write(elem[1]);%>> <%out.write(elem[0]);%></a></td>
                        <td><%out.write(elem[2]);%></td>
                    </tr>
                    <%
                        }

                    %>
                </tbody>

            </table>
        </div>
                  <form method="get" action="wikidataInformation.jsp">
                    <input type="submit" value="wikidata">
                </form>
    </body>
</html>
