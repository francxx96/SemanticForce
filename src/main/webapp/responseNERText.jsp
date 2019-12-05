
<%@page import="utils.OutputHandler"%>
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
            .index_group a {
                background-color: #4CAF50; /* Green background */
                border: 1px solid green; /* Green border */
                color: white; /* White text */
                padding: 10px 24px; /* Some padding */
                cursor: pointer; /* Pointer/hand icon */
                float: left; /* Float the buttons side by side */
                text-decoration: none; /* Remove underline */
                font-family: Verdana;
                width: 15%;
                text-align: center;
            }

              /* Clear floats (clearfix hack) */
            .index_group:after {
                content: "";
                clear: both;
                display: table;
            }

            .index_group a:not(:last-child) {
                border-right: none; /* Prevent double borders */
            }

              /* Add a background color on hover */
            .index_group a:hover {
                background-color: #3e8e41;
            }

             /* Center display */
            .index_group{
                position: relative;
                left: 40%;
            }
            footer{
                position:fixed; 
                width: 100%; 
                bottom:0;
                left:0;
                text-align:center;
                background-color:#4CAF50;
            }
            #footer_bar{
                text-decoration: none;
                color: black;
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
        <h1 id="title"> Entities in Text </h1>
        <img id="logo" src="img\logo.png">

        <br><br>
        <%
        String docText = NERresource.getDocumentText();
        //System.out.println("NERText: \n" + docText);
        ArrayList<Entity> entityList = NERresource.getEntities(docText);
        Entity currEntity;
        String subText;
        int i = 0, j = 0;

        while(i < docText.length()){
            if(j < entityList.size()){
                currEntity = entityList.get(j);
                //System.out.println(currEntity);
                //System.out.println("i="+i + "\tj="+j + "\tdocTextLen="+docText.length() + "\tseaLen="+entityList.size());
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

        OutputHandler.writeEntitiesFile(entityList);
        System.out.println("responseNERText saved");
        //System.out.println("LETTURA FILE:\n" + OutputHandler.readEntityArticlesFile());
        %>
        <br><br>
        
        
        <footer>
	<div id="footer_bar">
            <span style="background-color:red;font-weight:bold">Person</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:green;font-weight:bold">Location</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:orange;font-weight:bold">Organization</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:blue;font-weight:bold">Date</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:gold;font-weight:bold">Time</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:brown;font-weight:bold">Percent</span>&nbsp;&nbsp;&nbsp;
            <span style="background-color:violet;font-weight:bold">Money</span>&nbsp;&nbsp;&nbsp;
            
            <form style="float:right;" action="index.html">
                    <input  type="submit" id="bottone" value="HOME">
            </form>
        </div>
        </footer>
    </body>
    
</html>

