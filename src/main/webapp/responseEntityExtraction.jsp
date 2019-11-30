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
        <title>JSP Page</title>
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
            
            System.out.println(articlesEntities.toString());
        %>
        <div>
            <h1> Entities in Articles </h1>
            <%
             for(int i = 0; i<articles.size();i++){
                 String title = articles.get(i).getTitle();
                 for(Entity currEntity: articlesEntities.get(i).keySet()){
                    switch (currEntity.getType()) {
                        case "PERSON":
                            pers.add(currEntity);
                            person.add(pers);
                            break;
                        case "LOCATION":
                            loc.add(currEntity);
                            location.add(loc);
                            break;
                        case "ORGANIZATION":
                            org.add(currEntity);
                            organization.add(org);
                            break;
                        case "DATE":
                            dat.add(currEntity);
                            date.add(dat);
                            break;
                        case "TIME":
                            tim.add(currEntity);
                            time.add(tim);
                            break;
                        case "PERCENT":
                            perc.add(currEntity);
                            percentage.add(perc);
                            break;
                        case "MONEY":
                            mon.add(currEntity);
                            money.add(mon);
                            break;
                        default:
                            System.err.println("OTHER ENTITY");
                            break;
                    }
                }
                
                 
            }
             
            for(int i = 0; i<articles.size();i++){
                String title = articles.get(i).getTitle();
                String docText = articles.get(i).getText();
                ArrayList<Entity> entityList = entitiesList.get(i);
                int x = 0, y = 0;
                Entity currEntity;
                String subText;

                while(x < docText.length()){
                    if(y < entityList.size()){
                        currEntity = entityList.get(y);
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
                        x = currEntity.getPosition() + currEntity.getName().length();
                        y++;
                    } else{
                        subText = docText.substring(i);
                        %>
                            <span style="color:black"><%out.write(subText);%></span>
                        <%
                        x = docText.length();
                    }   
                }
                %>
                    <br><br><br>                               
                <%
            }
        %>
        </div>
    </body>
</html>
