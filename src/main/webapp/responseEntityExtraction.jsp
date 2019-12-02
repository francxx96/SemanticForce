<%-- 
    Document   : responseEntityExtraction
    Created on : 29-nov-2019, 9.17.54
    Author     : aless
--%>

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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Extracted Entities</title>
        <style type="text/css">
            body{
                background-color:#00ffbf;
            }
            .heading_section{
                text-align: center;
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
                color: red;
            }
        </style>
    </head>
    <body>
        <%   
            ArrayList<ArrayList<Entity>> entitiesList = new ArrayList();            

                    
            request.setCharacterEncoding("UTF-8");
            ArrayList<Article> articles = OutputHandler.readArticlesFile();
            ArrayList< HashMap<Entity,Integer> > articlesEntities = new ArrayList();
            
            for(Article art : articles){
                entitiesList.add(NERresource.getEntities(art.getText()));
            }
            
            System.out.println("\n\n\n"+entitiesList.toString());

        %>
        
        <div>
            <h1 id="title"> Entities in Articles </h1>
            <%
        
        for(int l=0; l<articles.size(); l++){       
            ArrayList<Entity> entityList = entitiesList.get(l);
            String docText = articles.get(l).getText();
            String title = articles.get(l).getTitle();
            int i = 0, j = 0;
            Entity currEntity;
            String subText;
            %>
                <h2 style="color:black"><%out.write(title);%></h2>
                <br>
            <%
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
                
            <hr class="separatorLine">               
            <%
        }

            %>
        </div>
    </body>
</html>
