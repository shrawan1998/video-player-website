<%-- 
    Document   : user_image
    Created on : 30 Feb, 2022, 7:32:46 PM
    Author     : skbag
--%>

<%@page contentType="text/html" import="java.io.*,java.sql.*" pageEncoding="UTF-8"%>
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
        String url="";
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web", "root", "");
            Statement st = cn.createStatement();
            ResultSet rs = st.executeQuery("select * from channel where email='"+email+"'");
            if(rs.next()){
                url="creater_home.jsp";
            }
            else{
                url="user_home.jsp";
            }
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
                saveFile = code+".jpg";
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
                    FileOutputStream fileOut = new FileOutputStream(request.getRealPath("/")+"/user_profile/"+saveFile);
                    // fileOut.write(dataBytes);
                    fileOut.write(dataBytes, startPos, (endPos - startPos));
                    fileOut.flush();
                    fileOut.close();
                    //imageSave="Success";
                    response.sendRedirect(url+"?success=1");
                }
                catch (FileNotFoundException e){
                    //imageSave="Failure";
                    out.println(e.getMessage());
                }
            }
            else{
                response.sendRedirect(url+"?again=1");
            }
        }
        catch(ClassNotFoundException e){
            out.println(e.getMessage());
        }
        catch(SQLException e){
            out.println(e.getMessage());
        }
    }
%>