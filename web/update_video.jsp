<%-- 
    Document   : update_video
    Created on : 28 Feb, 2022, 1:56:11 PM
    Author     : skbag
--%>

<%@page contentType="text/html" import="java.io.*" pageEncoding="UTF-8"%>
<%
    Cookie ct[]=request.getCookies();
    String email=null;
    for(int i=0; i<ct.length; i++){
        if(ct[i].getName().equals("login")){
            email=ct[i].getValue();
            break;
        }
    }
    if(email==null){
        response.sendRedirect("index.jsp");
    }
    else{
        String code=request.getParameter("code");
        
        String contentType = request.getContentType();
        //String imageSave=null;
        byte dataBytes[]=null;
        String saveFile=null;
        if((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)){
            DataInputStream in = new DataInputStream(request.getInputStream());
            int formDataLength = request.getContentLength();
            dataBytes = new byte[formDataLength];
            int byteRead = 0;
            int totalBytesRead = 0;
            while (totalBytesRead < formDataLength){
                byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
                totalBytesRead += byteRead;
            }
            String file = new String(dataBytes);
            /*saveFile = file.substring(file.indexOf("filename=\"") + 10);
            saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
            saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 1, saveFile.indexOf("\""));
            */
            saveFile = code+".mkv";
            // out.print(dataBytes);
            int lastIndex = contentType.lastIndexOf("=");
            String boundary = contentType.substring(lastIndex + 1, contentType.length());
            // out.println(boundary);
            int pos;
            pos = file.indexOf("filename=\"");
            pos = file.indexOf("\n", pos) + 1;
            pos = file.indexOf("\n", pos) + 1;
            pos = file.indexOf("\n", pos) + 1;
            int boundaryLocation = file.indexOf(boundary, pos) - 4;
            int startPos = ((file.substring(0, pos)).getBytes()).length;
            int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;
            try{
                FileOutputStream fileOut = new FileOutputStream(request.getRealPath("/")+"/videos/"+saveFile);
                // fileOut.write(dataBytes);
                fileOut.write(dataBytes, startPos, (endPos - startPos));
                fileOut.flush();
                fileOut.close();
                //imageSave="Success";
                response.sendRedirect("dashboard.jsp?success=1");
            }
            catch (FileNotFoundException e){
                //imageSave="Failure";
                out.println(e.getMessage());
            }
        }
        else{
            response.sendRedirect("edit.jsp?again=1");
        }
    }
%>
