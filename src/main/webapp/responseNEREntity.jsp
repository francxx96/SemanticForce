
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
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />        
        <link rel="icon" href="img\cg.png" type="image/x-icon"/>
        <style type="text/css">
            body{
                background-color:#00ffbf;
            }
            .heading_section{
                text-align: center;
            }
            .central_section{
                text-align: center;
            }
            #articlesSection{
                text-align:justify;   
            }
            #textStyle{
                font-family: verdana; 
                font-size: 10px;
            }
            .footerSection{
                text-align: center;
            }
            #footer_message{
                font-weight: bold;
                font-size: 24px;
                text-align: center;

            }
            #title{
                text-align:center;
                color: red;
            }
            a{
                text-decoration: none;
                color: black;
            }
            a:hover {
                color: black;
            }
            footer{
                position:fixed; 
                width: 100%; 
                bottom:0;
                left:0;
                text-align:center;
                background-color:green;
            }
            
            #footer_text{
                text-decoration: none;
                color: black;
            }
            #footer_text:hover {
                color: white;
            }
        </style>
    </head>
    
    <body>
        <h1 id="title">Recognized entities</h1>
        <br>
        <%
            ArrayList<Entity> pers = new ArrayList();
            ArrayList<Entity> org = new ArrayList();
            ArrayList<Entity> loc = new ArrayList();
            ArrayList<Entity> perc = new ArrayList();
            ArrayList<Entity> mon = new ArrayList();
            ArrayList<Entity> tim = new ArrayList();
            ArrayList<Entity> dat = new ArrayList();            
            ArrayList<Entity> num = new ArrayList();  
            
            request.setCharacterEncoding("UTF-8");
            String textArea = request.getParameter("textArea");
            //System.out.println("NEREntity: \n" + textArea);
            HashMap<Entity,Integer> enitityFreq = NERresource.getFreqEntities(textArea);
            System.out.println(textArea);
       
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
                    case "NUMBER":
                        num.add(currEntity);
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
                %> <li><%out.write("Name: " + currEntity.getName() + 
                        "\t- Occurrences: " + enitityFreq.get(currEntity) +
                        "\t- Basic Dependencies: " + currEntity.getKeyWords());%></li> <%
            }
                %> </ul> <%
        } 

        if(!loc.isEmpty()){
            %>
                <br> 
                <a style="color:green; font-size:18px"> LOCATION </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: loc){
                %> <li><%out.write("Name: " + currEntity.getName() + 
                        "\t- Occurrences: " + enitityFreq.get(currEntity) +
                        "\t- Basic Dependencies: " + currEntity.getKeyWords());%></li> <%
            }  
                %> </ul> <%
        }    
                
        if(!org.isEmpty()){
            %>
                <br> 
                <a style="color:orange; font-size:18px"> ORGANIZATION </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: org){
                %> <li><%out.write("Name: " + currEntity.getName() + 
                        "\t- Occurrences: " + enitityFreq.get(currEntity) +
                        "\t- Basic Dependencies: " + currEntity.getKeyWords());%></li> <%
            }    
                %> </ul> <% 
        }    
                
        if(!dat.isEmpty()){
            %>
                <br> 
                <a style="color:blue; font-size:18px"> DATE </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: dat){
                %> <li><%out.write("Name: " + currEntity.getName() + 
                        "\t- Occurrences: " + enitityFreq.get(currEntity) +
                        "\t- Basic Dependencies: " + currEntity.getKeyWords());%></li> <%
            }
                %> </ul> <%
        }    
                
        if(!tim.isEmpty()){
            %>
                <br> 
                <a style="color:gold; font-size:18px"> TIME </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: tim){
                %> <li><%out.write("Name: " + currEntity.getName() + 
                        "\t- Occurrences: " + enitityFreq.get(currEntity) +
                        "\t- Basic Dependencies: " + currEntity.getKeyWords());%></li> <%
            }
                %> </ul> <%
        }    
         
        if(!perc.isEmpty()){
            %>
                <br> 
                <a style="color:brown; font-size:18px"> PERCENT </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: perc){
                %> <li><%out.write("Name: " + currEntity.getName() + 
                        "\t- Occurrences: " + enitityFreq.get(currEntity) +
                        "\t- Basic Dependencies: " + currEntity.getKeyWords());%></li> <%
            }
                %> </ul> <%
        }    
                
        if(!mon.isEmpty()){
            %>
                <br> 
                <a style="color:violet; font-size:18px"> MONEY </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: mon){
                %> <li><%out.write("Name: " + currEntity.getName() + 
                        "\t- Occurrences: " + enitityFreq.get(currEntity) +
                        "\t- Basic Dependencies: " + currEntity.getKeyWords());%></li> <%
            }
                %> </ul> <%
        }    
            
        if(!num.isEmpty()){
            %>
                <br> 
                <a style="color:pink; font-size:18px"> NUMBER </a> 
                <br>
                <ul style="list-style-type:disc;">
            <%
            for(Entity currEntity: num){
                %> <li><%out.write("Name: " + currEntity.getName() + 
                        "\t- Occurrences: " + enitityFreq.get(currEntity) +
                        "\t- Basic Dependencies: " + currEntity.getKeyWords());%></li> <%
            }  
                %> </ul> <%
        }    
            %> 
            <br><br>
            <div class="footer_section">
                <span id="footer_message">Press the button to display them within the text</span> 
                <br>
                <form method="POST" action="responseNERText.jsp" autocomplete="off" >
                    <input type="submit" value="ENTITY">
                </form>
                <br>
            </div>
        <footer>
            <a id="footer_text" href="questions.html">Questions? Consult this section</a>
        </footer>
    </body>
</html>
