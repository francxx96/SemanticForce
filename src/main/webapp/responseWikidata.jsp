
<%@page import="wikidata.wikidata"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SemanticForce</title>
        <link rel="icon" href="img\logo.png" type="image/x-icon"/>

        <style>
            .myBox {
                border: groove;
                padding: 5px;
                font: 24px/36px Verdana;
                width: 90%;
                height: 550px;
                overflow: scroll;
                background-color: white;
                margin-left: auto;
                margin-right: auto;
            }
            body{
                background-color:#00ffbf;
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
                font-family:Verdana;
                text-align: left;
                width:200px;
                padding-left: 5px;
                vertical-align: top;
                color: green;
                font-weight: bold;
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
        </style>
    </head>

    <body>
        <img id="logo" src="img\logo.png">
        <h1 id="title">Research executed</h1>
        <br>
        <%
            // questo è il parametro che vi passa l'input nella pagina precedente
            request.setCharacterEncoding("UTF-8");
            String parameter = request.getParameter("entityWiki");
            System.out.println("parameter " + parameter);
            String[] kWords = {" "};

            try {
                kWords = request.getParameter("keyWords").split(",");
            } catch (NullPointerException e) {
                System.out.println("Entita senza prole chiavi");

                kWords[0] = " ";
            }

            //System.out.println("entity for wikidata = " + parameter);
            for(String str : kWords){
                System.out.println("Kwords " + str);
            }

            ArrayList<String[]> list = new ArrayList();
            list = wikidata.executeGet(parameter);
            ArrayList<String[]> filtrate = new ArrayList();
            boolean flag = false;
            String desc;

            for (String[] elem : list) {
                desc = elem[2];

                for (String word : kWords) {

                    if (desc.contains(word)) {

                        flag = true;
                    }

                }

                if (flag == true) {
                    filtrate.add(elem);
                }
                flag = false;
            }

            // se non vengono trovate entità che matchano le parole chiave ritorno le prime 10 trovate da wikidata
            if (filtrate.isEmpty()) {
                int size = list.size();
                if (size < 10) {
                    int i = 0;
                    for (i = 0; i < size; i++) {
                        System.out.println("Entità corrente" + list.get(i).toString());

                        filtrate.add(i, list.get(i));
                    }
                } else {
                    int i = 0;
                    for (i = 0; i < 10; i++) {
                        System.out.println("Entità corrente" + list.get(i).toString());

                        filtrate.add(i, list.get(i));
                    }
                }

            }


        %>
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
                    <% for (String[] elem : filtrate) {

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
        <br>
        <div style="position:absolute; left:45%">
            <div style="float: left;">
            <input onClick="javascript:history.back();" id="bottone" type="submit" value="BACK">
            </div>
            <div style="float : left;"><form method="get" action="index.html">
                <input id="bottone" type="submit" value="HOME">
            </form>
            </div>
        </div>    
    </body>
</html>


