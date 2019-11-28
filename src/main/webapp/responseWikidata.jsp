<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .myBox {
                    border: groove;
                    padding: 5px;
                    font: 24px/36px sans-serif;
                    width: 60%;
                    height: 200px;
                    overflow: scroll;
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
        </style>
    </head>
    
    <body>
        <%    
            // questo è il parametro che vi passa l'input nella pagina precedente
            request.setCharacterEncoding("UTF-8");
            String parameter = request.getParameter("entityWiki");
            System.out.println("enity for wikidata = " + parameter);
            
        %>
    </body>
</html>
