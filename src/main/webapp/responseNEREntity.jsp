
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ner.Entity"%>
<%@page import="ner.NERresource"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>NER Extraction</title>
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
            <li><a href="indexNER.html">Entity Recognition</a></li>
            <li><a href="elastic.html">Elasticsearch</a></li>
            <li><a href="activities.html">Activities</a></li>
            <li><a href="contact.html">Contact</a></li>
        </ul>
        <br><br><br><br><br><br>
        <%
            ArrayList<Entity> pers = new ArrayList();
            ArrayList<Entity> org = new ArrayList();
            ArrayList<Entity> loc = new ArrayList();
            ArrayList<Entity> perc = new ArrayList();
            ArrayList<Entity> mon = new ArrayList();
            ArrayList<Entity> tim = new ArrayList();
            ArrayList<Entity> dat = new ArrayList();            
            
            request.setCharacterEncoding("UTF-8");
            String textArea = request.getParameter("textArea");
            HashMap<Entity,Integer> enitityFreq = NERresource.getEntities(textArea);
            System.out.println(textArea);
        %>
        <div style="text-align: center">
        <span style="font-weight: bold; font-size: 25px">Recognized entities</span>
        <br>
        </div>
        <span style="font-weight: bold;font-size: 18px; color:blue">Press the button to display them within the text</span> 
        <br>
        <form method="POST" action="responseNERText.jsp" autocomplete="off" >
            <input type="submit" value="ENTITY COLOUR" style="font-size: 18px">
        </form>
        <br> 
        <%
            for(Entity currEntity: enitityFreq.keySet()){
                switch (currEntity.getType()) {
                    case "PERSON":
                        pers.add(currEntity);
                        break;
                    case "LOCATION":
                        loc.add(currEntity);
                        break;
                    case "ORGANIZATION":
                        org.add(currEntity);
                        break;
                    case "DATE":
                        dat.add(currEntity);
                        break;
                    case "TIME":
                        tim.add(currEntity);
                        break;
                    case "PERCENT":
                        perc.add(currEntity);
                        break;
                    case "MONEY":
                        mon.add(currEntity);
                        break;
                    default:
                        System.err.println("OTHER ENTITY");
                        break;
                }
            }

        if(!pers.isEmpty()){
            %>
                <br> 
                <a style="color:red; font-size:18px"> PERSON </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: pers){
                %> <li><%out.write("Name: " + currEntity.getName() + " - Occurrences: " + enitityFreq.get(currEntity));%></li> <%
            }    
        }    
            %> </ul> <%
        if(!loc.isEmpty()){
            %>
                <br> 
                <a style="color:green; font-size:18px"> LOCATION </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: loc){
                %> <li><%out.write("Name: " + currEntity.getName() + "\t- Occurrences: " + enitityFreq.get(currEntity));%></li> <%
            }    
        }    
            %> </ul> <%
                
        if(!org.isEmpty()){
            %>
                <br> 
                <a style="color:orange; font-size:18px"> ORGANIZATION </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: org){
                %> <li><%out.write("Name: " + currEntity.getName() + "\t- Occurrences: " + enitityFreq.get(currEntity));%></li> <%
            }    
        }    
            %> </ul> <%
                
        if(!dat.isEmpty()){
            %>
                <br> 
                <a style="color:blue; font-size:18px"> DATE </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: dat){
                %> <li><%out.write("Name: " + currEntity.getName() + "\t- Occurrences: " + enitityFreq.get(currEntity));%></li> <%
            }    
        }    
            %> </ul> <%
                
        if(!tim.isEmpty()){
            %>
                <br> 
                <a style="color:gold; font-size:18px"> TIME </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: tim){
                %> <li><%out.write("Name: " + currEntity.getName() + "\t- Occurrences: " + enitityFreq.get(currEntity));%></li> <%
            }    
        }    
            %> </ul> <%
                
        if(!perc.isEmpty()){
            %>
                <br> 
                <a style="color:brown; font-size:18px"> PERCENT </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: perc){
                %> <li><%out.write("Name: " + currEntity.getName() + "\t- Occurrences: " + enitityFreq.get(currEntity));%></li> <%
            }    
        }    
            %> </ul> <%
                
        if(!mon.isEmpty()){
            %>
                <br> 
                <a style="color:violet; font-size:18px"> MONEY </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: mon){
                %> <li><%out.write("Name: " + currEntity.getName() + "\t- Occurrences: " + enitityFreq.get(currEntity));%></li> <%
            }    
        }    
            %> 
                </ul>
                
    </body>
</html>
