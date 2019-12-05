
<%@page import="java.util.Set"%>
<%@page import="crawlingScraping.Article"%>
<%@page import="utils.OutputHandler"%>
<%@page import="java.util.HashMap"%>
<%@page import="ner.NERresource"%>
<%@page import="ner.Entity"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link rel="icon" href="img\logo.png" type="image/x-icon"/>
        <title>SemanticForce</title>
        <style type="text/css">
            body{
                background-color:#00ffbf;
            }
            #articlesSection{
                text-align:justify;   
            }
            #titleStyle{}
            #URLStyle{}
            #textStyle{
                font-family: verdana; 
                font-size: 10px;
            }
            .footerSection{
                text-align: center;
            }
            .separatorLine{
                border: 2px dashed black;
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
                background-color:#4CAF50;
            }
            #footer_bar{       
                text-align: center;
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
            
        </style>
    </head>
    <body>
        <img id="logo" src="img\logo.png">
        <h1 id="title">Extracted Entities</h1>
        <br>
        <%   
            ArrayList<ArrayList<Entity>> entityArticleList = new ArrayList();
            ArrayList<Article> articles = OutputHandler.readArticlesFile();
            
            for(Article art : articles){
                entityArticleList.add(NERresource.getEntities(art.getText()));
            }
        %>
        
        <div>
            <%
        
        for(int l=0; l<articles.size(); l++){       
            ArrayList<Entity> entityList = entityArticleList.get(l);
            String docText = articles.get(l).getText();
            String title = articles.get(l).getTitle();
            Entity currEntity;
            String subText;
            int i=0, j=0;
            %>
                <h2 style="color:black"> <%out.write(title);%> </h2>
                <br>
            <%
            while(i < docText.length()){
                if(j < entityList.size()){
                    currEntity = entityList.get(j);
                    //System.out.println("ENTITY name="+currEntity.getName()+"*\toffset="+currEntity.getPosition()+"\ttype="+currEntity.getType());
                    subText = docText.substring(i, currEntity.getStartPos()); // get another part of text before the new entity 
                    %>
                        <span style="color:black; font-family: Verdana; font-size: 16px;"><%out.write(subText);%></span>
                <%
                switch (currEntity.getType()) {
                    case "PERSON":
                        %>
                            <span style="color:red; font-weight: bold; font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%></span>
                        <%
                        break;
                    case "LOCATION":
                        %>
                            <span style="color:green; font-weight: bold; font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%></span>
                        <%
                        break;
                    case "ORGANIZATION":
                        %>
                            <span style="color:orange; font-weight: bold; font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%></span>
                        <%
                        break;
                    case "DATE":
                        %>
                            <span style="color:blue; font-weight: bold; font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%></span>
                        <%
                        break;
                    case "TIME":
                        %>
                            <span style="color:gold; font-weight: bold; font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%></span>
                        <%
                        break;
                    case "PERCENT":
                        %>
                            <span style="color:brown; font-weight: bold; font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%></span>
                        <%
                        break;
                    case "MONEY":
                        %>
                            <span style="color:violet; font-weight: bold; font-size: 16px; font-family: Verdana;"><%out.write(currEntity.getName());%></span>
                        <%
                        break;
                    default:
                        System.out.println("OTHER ENTITY in responseEntityExtraction: " + currEntity);
                        %>
                            <span style="color:black; font-family: Verdana; font-size: 16px;"><%out.write(currEntity.getName());%></span>
                        <%
                        break;
                }    
                i = currEntity.getEndPos();
                j++;
            } else{
                subText = docText.substring(i);
                %>
                    <span style="color:black; font-family: Verdana; font-size: 16px;"><%out.write(subText);%></span>
                <%
                i = docText.length();
                }   
            }
            %>
            <br><br><br>
            <hr class="separatorLine">               
        <%
        }

        OutputHandler.writeEntityArticleFile(entityArticleList);           
        System.out.println("responseEntityExtraction file saved");
        //System.out.println("LETTURA FILE:\n" + OutputHandler.readEntityArticlesFile());
        %>
        </div>
        <br>
        <footer>
	<div id="footer_bar">
            <span style="background-color:red;font-weight:bold">Person</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:green;font-weight:bold">Location</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:orange;font-weight:bold">Organization</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:blue;font-weight:bold">Date</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:gold;font-weight:bold">Time</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:brown;font-weight:bold">Percent</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:violet;font-weight:bold">Money</span>&nbsp;&nbsp;&nbsp;
            
            <form style="float:right;"method="GET" action="responseWikiExtraction.jsp">
                    <input  type="submit" id="bottone" value="GO to WikiData!">
            </form>
        </div>
        </footer>
    </body>

</html>
