<%-- 
    Document   : creater_favourite.jsp
    Created on : 6 Mar, 2022, 8:20:20 PM
    Author     : skbag
--%>

<%@page import="java.util.TimeZone"%>
<%@page contentType="text/html" import="java.sql.*,java.text.*,java.util.Date" pageEncoding="UTF-8"%>
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
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web", "root", "");
        %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Project</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="style.css">
    <script src="jquery-3.6.0.min.js"></script>
    <script>
        $(document).on("click",".remove",function(){
            var code=$(this).attr("id");
            $.post(
                    "remove_favorite.jsp",{code:code},function(data){
                        if(data.length==10){
                            $("#f-"+code).fadeOut(1000);
                        }
                    }
                );
        });
    </script>
</head>

<body>
    <!------navbar starts-->
    <nav class="flex-div">
        <div class="nav-left flex-div">
            <i id="menu" class="material-icons">menu</i>
            <img src="images/logo.png" alt="" class="logo">
        </div>
        <div class="nav-middle flex-div">
            <div class="search-box flex-div">
                <input type="text" placeholder="Type here to search">
                <a href=""><i class="material-icons flex-div">search</i></a>
            </div>
        </div>
        <div class="nav-right flex-div">
            <a href="dashboard.jsp"><i class="material-icons flex-div">videocam</i></a>
            <a href="logout.jsp"><i class="material-icons flex-div">power_settings_new</i></a>
            <i class="material-icons display-this" data-toggle="modal" data-target="#user_info_Modal">account_circle</i>
        </div>
    </nav>
    <!-----navbar ends-->
    <!-----sidebar starts-->
    <div class="sidebar">
        <div class="shortcut-links">
            <a href="creater_home.jsp"><i class="material-icons">home</i><span>Home</span></a>
            <a href="dashboard.jsp"><i class="material-icons">dashboard</i><span>Dashboard</span></a>
            <a href="creater_favourite.jsp" class="active"><i class="material-icons">library_add_check</i><span>Favourite</span></a>
            <a href="creater_history.jsp"><i class="material-icons">history</i><span>History</span></a>
            <a href="watch_later.jsp"><i class="material-icons">watch_later</i><span>Watch Later</span></a>
            <a href="creater_liked.jsp"><i class="material-icons">thumb_up</i><span>Liked Videos</span></a>
            <hr>
        </div>
        <div class="subscribed-list">
            <h3>SUBSCRIBED</h3>
            <%
                Statement stch=cn.createStatement();
                ResultSet rsch=stch.executeQuery("select * from channel where code IN(select channel_code from subscribe where user_email='"+email+"') limit 5");
                while(rsch.next()){
                    %>
                    <a href=""><img src="channel_profile/<%=rsch.getString("code")%>.jpg"><span><%=rsch.getString("channel_name")%></span></a>
                    <%
                }
            %>
        </div>
    </div>
    <!------sidebar ends-->
    
    <!------main video body-->
    <!-- The Modal Start-->
    <div class="container">
        <div class="modal fade" id="user_info_Modal">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <!-- Modal Header -->
                    <div class="modal-header" style="background-color:#db4437">
                        <h4 class="modal-title" style="color: white">User Profile</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <!-- Modal body -->
                    <%
                        Statement stus = cn.createStatement();
                        ResultSet rsus = stus.executeQuery("select * from user_info where email='"+email+"'");
                        if(rsus.next()){
                            %>
                            <div class="modal-body">
                                <div>
                                    <label><img src="user_profile/<%=rsus.getString("code")%>.jpg" class="img rounded" width="70px"/></label>
                                </div>
                                <div>
                                    <label style="color:black;font-size:15px">Name: </label>&nbsp;<label style="color:gray;font-size:15px"><%=rsus.getString("name")%></label>
                                </div>
                                <div>
                                    <label style="color:black;font-size:15px">Email: </label>&nbsp;<label style="color:gray;font-size:15px"> <%=rsus.getString("email")%></label>
                                </div>
                                <div>
                                    <label style="color:black;font-size:15px">Password: </label>&nbsp;<label style="color:gray;font-size:15px"> <%=rsus.getString("password")%></label>
                                </div>
                                <form action="user_image.jsp?code=<%=rsus.getString("code")%>" method="post" enctype="multipart/form-data">
                                    <div class="form-group1">
                                        <span>Upload Image:</span><br><input type="file" name="photo">
                                        <button type="submit" class="btn btn-success">Upload</button>
                                    </div>
                                </form>
                            </div>
                            <%
                        }
                    %>
                    <!-- Modal footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!---The Modal end-->


    <div class="videos-container">
        <div class="list-container">
            <%
                Statement st=cn.createStatement();
                ResultSet rs=st.executeQuery("select * from video_favorite where email='"+email+"'");
                while(rs.next()){
                    //taking channel details
                    String channel_name="";
                    Statement stmt=cn.createStatement();
                    ResultSet rss=stmt.executeQuery("select * from channel where code IN(select ccode from video where code='"+rs.getString("videocode")+"')");
                    if(rss.next()){
                        channel_name=rss.getString("channel_name");
                    }
                    Statement st1=cn.createStatement();
                    ResultSet rs1=st1.executeQuery("select * from video where code='"+rs.getString("videocode")+"'");
                    if(rs1.next()){
                        String videocode=rs1.getString("code");
                        //Taking video posting date
                        String postDate=rs1.getString("dt");
                        //generating current date
                        SimpleDateFormat sdf=new SimpleDateFormat("HH:mm dd-MM-yyyy");
                        sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata"));
                        java.util.Date d=new java.util.Date();
                        String currentDate=sdf.format(d)+"";
                        Date date1=null, date2=null;
                        date1=sdf.parse(currentDate);
                        date2=sdf.parse(postDate);
                        long diff=date1.getTime()-date2.getTime();
                        int daysBtn=(int)(diff/(1000*60*60*24));
                        //counting total views
                        int views_count=0;
                        Statement st_view=cn.createStatement();
                        ResultSet rs_view=st_view.executeQuery("select count(*) from views where videocode='"+rs1.getString("code")+"'");
                        if(rs_view.next()){
                            views_count=rs_view.getInt(1);
                        }
                        %>
                        <div class="vid-list" id="f-<%=rs1.getString("code")%>">
                            <a href="creater_play_video.jsp?code=<%=rs1.getString("code")%>"><img src="thumbnails/<%=videocode%>.jpg" class="thumbnail" alt=""></a>
                            <div class="flex-div">
                                <img src="channel_profile/<%=rs1.getString("ccode")%>.jpg">
                                <div class="vid-info">
                                    <a href="creater_play_video.jsp?code=<%=rs1.getString("code")%>"><%=rs1.getString("title")%></a>
                                    <p><%=channel_name%></p>
                                    <p><%=views_count%> Views &bull; <%=daysBtn%> days ago</p>
                                </div>
                            </div>
                            <div class="vid-edit">
                                <a class="remove" id='<%=rs1.getString("code")%>' style="cursor:pointer; color: red"><i class="fa fa-trash" aria-hidden="true"></i> Remove</a>
                            </div>
                        </div>
                    <%
                    }
                }
                cn.close();
            %>
        </div>
    </div>
    
    <script src="jquery-3.6.0.min.js"></script>
    <!-- Popper js -->
    <script src="js/bootstrap/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="js/bootstrap/bootstrap.min.js"></script>
    <!-- All Plugins js -->
    <script src="js/plugins/plugins.js"></script>
    <!-- custom js -->
    <script src="script.js"></script>
</body>
</html>
<%
        }
        catch(ClassNotFoundException e){
            out.println(e.getMessage());
        }
        catch(SQLException e){
            out.println(e.getMessage());
        }
    }
%>
