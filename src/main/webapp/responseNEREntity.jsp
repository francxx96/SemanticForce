
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ner.Entity"%>
<%@page import="ner.NERresource"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>SemanticForce</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />        
        <link rel="icon" href="img\logo.png" type="image/x-icon"/>
        <style type="text/css">
            body{
                background-color:#00ffbf;
            }
            #logo{
                position: absolute;
                right: 5%;
                top: 0%;
                height: 80px;
                width: 85px
            }
            #articlesSection{
                text-align:justify;   
            }
            #textStyle{
                font-family: verdana; 
                font-size: 10px;
            }
            #footerSection{
                text-align:center;
            }
            #footer_message{
                font-weight: bold;
                font-size: 24px;
                text-align: center;

            }
            #title{
                text-align:center;
                font-family: Verdana;
            }
            footer{
                position:fixed; 
                width: 100%; 
                bottom:0;
                left:0;
                text-align:center;
                background-color:green;
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
        </style>
    </head>
    
    <body>
        <h1 id="title">Recognized entities</h1>
        <img id="logo" src="img\logo.png">
        <br>
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
            //System.out.println("NEREntity: \n" + textArea);
            HashMap<Entity,Integer> enitityFreq = NERresource.getFreqEntities(textArea);
            //System.out.println(textArea);
       
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
                        System.err.println("OTHER ENTITY: " + currEntity);
                        break;
                }
            }
            
        if(!pers.isEmpty()){
            %>
                <br> 
                <a style="color:red; font-size:18px; font-family: Verdana; font-weight: bold; "> PERSON </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: pers){
                %> <li>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write("Name: ");%> </span>
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Occurrences:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + enitityFreq.get(currEntity));%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Basic Dependencies:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + currEntity.getKeyWords());%> </span>

                   </li> <%
            }
                %> </ul> <%
        } 

        if(!loc.isEmpty()){
            %>
                <br> 
                <a style="color:green; font-size:18px; font-family: Verdana; font-weight: bold;"> LOCATION </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: loc){
                %> <li>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write("Name: ");%> </span>
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Occurrences:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + enitityFreq.get(currEntity));%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Basic Dependencies:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + currEntity.getKeyWords());%> </span>

                   </li> <%
            }
                %> </ul> <%
        }    
                
        if(!org.isEmpty()){
            %>
                <br> 
                <a style="color:orange; font-size:18px; font-family: Verdana; font-weight: bold;"> ORGANIZATION </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: org){
                %> <li>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write("Name: ");%> </span>
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Occurrences:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + enitityFreq.get(currEntity));%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Basic Dependencies:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + currEntity.getKeyWords());%> </span>

                   </li> <%
            }    
                %> </ul> <% 
        }    
                
        if(!dat.isEmpty()){
            %>
                <br> 
                <a style="color:blue; font-size:18px; font-family: Verdana; font-weight: bold;"> DATE </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: dat){
                %> <li>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write("Name: ");%> </span>
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Occurrences:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + enitityFreq.get(currEntity));%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Basic Dependencies:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + currEntity.getKeyWords());%> </span>

                   </li> <%
            }
                %> </ul> <%
        }    
                
        if(!tim.isEmpty()){
            %>
                <br> 
                <a style="color:gold; font-size:18px; font-family: Verdana; font-weight: bold;"> TIME </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: tim){
                %> <li>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write("Name: ");%> </span>
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Occurrences:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + enitityFreq.get(currEntity));%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Basic Dependencies:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + currEntity.getKeyWords());%> </span>

                   </li> <%
            }
                %> </ul> <%
        }    
         
        if(!perc.isEmpty()){
            %>
                <br> 
                <a style="color:brown; font-size:18px; font-family: Verdana; font-weight: bold;"> PERCENT </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: perc){
                %> <li>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write("Name: ");%> </span>
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Occurrences:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + enitityFreq.get(currEntity));%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Basic Dependencies:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + currEntity.getKeyWords());%> </span>

                   </li> <%
            }
                %> </ul> <%
        }    
                
        if(!mon.isEmpty()){
            %>
                <br> 
                <a style="color:violet; font-size:18px; font-family: Verdana; font-weight: bold;"> MONEY </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: mon){
                %> <li>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write("Name: ");%> </span>
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Occurrences:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + enitityFreq.get(currEntity));%> </span>
                    <span style="font-size: 16px; font-family: Verdana; font-weight: bold;"><%out.write(" - Basic Dependencies:");%> </span> 
                    <span style="font-size: 16px; font-family: Verdana;"><%out.write(" " + currEntity.getKeyWords());%> </span>

                   </li> <%
            }
                %> </ul> <%
        }    
           
        %> 
            <br><br><br>
            
            <div style="text-align:center;">
            <span id="footer_message">Press the button to display them within the text</span>
            <br><br>
            <form method="POST" action="responseNERText.jsp" autocomplete="off" >
                <input  type="submit" id="bottone" value="GO!">
            </form>
            </div>
            
            
    </body>
</html>
