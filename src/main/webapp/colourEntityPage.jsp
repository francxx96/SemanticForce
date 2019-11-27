<%@page import="java.io.IOException"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ner.Entity"%>
<%@page import="ner.NERresource"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Entity Recognizer "C.G"</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">        
        <link rel="icon" href="img\cg.png" type="image/x-icon"/>
        <style>
            ul#menu li:hover{
                background-color:green;
            }

            ul#menu {
               font-family: Verdana, sans-serif;
               font-size: 18px;
            }

            ul#menu li {
                background-color: blue;
                display: inline;
                margin: 1px;
                float: left; 
                border-radius:10px 10px 10px 10px;
            }

            ul#menu li a {
                color: #fff;
                display: block;
                font-weight: bold;
                line-height: 40px;
                text-decoration: none;
                width: 244px;
                height: 40px;
                text-align: center;
            }
        </style>
    </head>
    
    <body background="img\Sfondo.png">
        <a style="font-size: 50px;color:green;position: absolute;right:38%; font-family: Verdana, sans-serif">Entity Recognizer</a>
        <img src="img\cg.png" style="position: absolute;right :0px;top: 0; margin: 10px; height: 90px; width: 100px">
        <br><br><br><br>
            <ul id="menu" style="position:absolute;right:9%">
                <li><a href="index.html">Home</a></li>
                <li><a href="textNER.html">Entity Recognition</a></li>
                <li><a href="elastic.html">Elasticsearch</a></li>
                <li><a href="activities.html">Activities</a></li>
                <li><a href="contact.html">Contact</a></li>
            </ul>
        <br><br><br><br><br><br>      
        <%
            ArrayList<Entity> entityList = NERresource.getEntities();
            String docText = NERresource.getDocumentText();
            int i = 0, j = 0;
            Entity currEntity;
            String subText;
            
            while(i < docText.length()){
                if(j < entityList.size()){
                    currEntity = entityList.get(j);
                    System.out.println("ENTITY name="+currEntity.getName()+"*\toffset="+currEntity.getPosition()+"\ttype="+currEntity.getType());
                    //System.out.println("i="+ i + "\tj="+ j + "\tdocTextLen="+ docText.length()+ "\tseaLen="+ entityList.size() );
                    subText = docText.substring(i, currEntity.getPosition()); // get another part of text before the new entity 
                    System.out.println("subText="+subText+"*****************");
                    %>
                        <span style="color:black"><%out.write(subText);%></span>
                    <%
                    switch (currEntity.getType()) {
                        case "PERSON":
                            %>
                                <span style="color:red; font-weight: bold"><%out.write(currEntity.getName());%></span>
                            <%
                            break;
                        case "LOCATION":
                            %>
                                <span style="color:green; font-weight: bold"><%out.write(currEntity.getName());%></span>
                            <%
                            break;
                        case "ORGANIZATION":
                            %>
                                <span style="color:orange; font-weight: bold"><%out.write(currEntity.getName());%></span>
                            <%
                            break;
                        case "DATE":
                            %>
                                <span style="color:blue; font-weight: bold"><%out.write(currEntity.getName());%></span>
                            <%
                            break;
                        case "TIME":
                            %>
                                <span style="color:gold; font-weight: bold"><%out.write(currEntity.getName());%></span>
                            <%
                            break;
                        case "PERCENT":
                            %>
                                <span style="color:brown; font-weight: bold"><%out.write(currEntity.getName());%></span>
                            <%
                            break;
                        case "MONEY":
                            %>
                                <span style="color:violet; font-weight: bold"><%out.write(currEntity.getName());%></span>
                            <%
                            break;
                        default:
                            System.err.println("ERROR: OTHER ENTITY");
                            break;
                    }    
                    i = currEntity.getPosition() + currEntity.getName().length();
                    j++;
                } else{
                    subText = docText.substring(i);
                    %>
                        <span style="color:black"><%out.write(subText);%></span>
                    <%
                    i = docText.length();
                }   
            }

            Gson gson = new Gson();
            String userJson = gson.toJson(entityList);
           
            FileWriter w;
            BufferedWriter bw;
            try {
                w = new FileWriter("../Source Packages/text.json");
                bw=new BufferedWriter(w);
                bw.write(userJson);
                bw.flush();
                bw.close();            
            } catch (IOException ex) {
                System.out.println(ex);
            }

            %>
        <br><br><br>
        <div style="text-align: center">
            <span style="background-color:red;font-weight:bold">Person</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:green;font-weight:bold">Location</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:orange;font-weight:bold">Organization</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:blue;font-weight:bold">Date</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:gold;font-weight:bold">Time</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:brown;font-weight:bold">Percent</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:violet;font-weight:bold">Money</span>&nbsp;&nbsp;&nbsp;
        </div>
    </body>
</html>
