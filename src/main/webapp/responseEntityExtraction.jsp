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
            }
        </style>
    </head>
    <body>
        <%
            ArrayList<Entity> pers= new ArrayList();
            ArrayList<Entity> org = new ArrayList();
            ArrayList<Entity> loc = new ArrayList();
            ArrayList<Entity> perc = new ArrayList();
            ArrayList<Entity> mon = new ArrayList();
            ArrayList<Entity> tim = new ArrayList();
            ArrayList<Entity> dat = new ArrayList();            
            
            ArrayList<ArrayList<Entity>> person = new ArrayList();
            ArrayList<ArrayList<Entity>> organization = new ArrayList();
            ArrayList<ArrayList<Entity>> location = new ArrayList();
            ArrayList<ArrayList<Entity>> percentage = new ArrayList();
            ArrayList<ArrayList<Entity>> money = new ArrayList();
            ArrayList<ArrayList<Entity>> time = new ArrayList();
            ArrayList<ArrayList<Entity>> date = new ArrayList();            
            
            ArrayList<ArrayList<Entity>> entitiesList = new ArrayList();            

                    
            request.setCharacterEncoding("UTF-8");
            ArrayList<Article> articles = OutputHandler.readArticlesFile();
            ArrayList< HashMap<Entity,Integer> > articlesEntities = new ArrayList();
            
            for(Article art : articles){
                HashMap<Entity,Integer> entityFreq = NERresource.getEntities(art.getText());
                articlesEntities.add(entityFreq);
                ArrayList<Entity> entityy = NERresource.getEntities();
                entitiesList.add(entityy);
            }
            
            System.out.println("\n\n\n"+entitiesList.toString());

        %>
        
        <div>
            <h1 id="title"> Entities in Articles </h1>
            <%
             for(int i = 0; i<articles.size();i++){
                 for(Entity currEntity: articlesEntities.get(i).keySet()){
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
                    person.add(pers);
                    location.add(loc);
                    organization.add(org);
                    date.add(dat);
                    time.add(tim);
                    percentage.add(perc);
                    money.add(mon);
                }
             
             
        for(int l=0; l<articles.size(); l++){       
            ArrayList<Entity> entityList = entitiesList.get(l);
            String docText = articles.get(l).getText();
            String title = articles.get(l).getTitle();
            int i = 0, j = 0;
            Entity currEntity;
            String subText;
            %>
                <h2 style="color:black"><%out.write(title);%></h2>
                <br><br><br>
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
                    <hr class="separatorLine">               
               <%
        }

            
            %>
        </div>
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
