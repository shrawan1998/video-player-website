<%-- 
    Document   : index
    Created on : 12 Feb, 2022, 2:48:40 AM
    Author     : skbag
--%>

<%@page import="java.util.TimeZone"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page contentType="text/html" import="java.sql.*,java.text.*,java.util.Date" pageEncoding="UTF-8"%>
<%
    try{
        Cookie ct[]=request.getCookies();
        String email=null;
        for(int i=0; i<ct.length; i++){
            if(ct[i].getName().equals("login")){
                email=ct[i].getValue();
                break;
            }
        }
        if(email!=null){
            response.sendRedirect("creater_home.jsp");
        }
        else{
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
    <!-- font-awesome css-->
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'>
    <!---Bootstrap css---->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
    <script src="jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="style.css">
    <script>
        $(document).on("click", "#signup_btn", function () {
            $("#signupModal").modal();
        });
        $(document).on("click", "#login_btn", function () {
            $("#loginModal").modal();
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
                <input type="text" name="search" placeholder="Type here to search">
                <button class="srch-btn" data-toggle="modal" data-target="#loginModal"><i class="material-icons flex-div">search</i></button>
            </div>
        </div>
        <div class="nav-right flex-div">
            <a href="index.jsp"><i class="material-icons flex-div" style="color: red">home</i></a>
            <i class="material-icons" data-toggle="modal" data-target="#loginModal">videocam</i>
            <i class="material-icons display-this" data-toggle="modal" data-target="#loginModal">account_circle</i>
        </div>
    </nav>
    <!-----navbar ends-->
    <!-----sidebar starts-->
    <div class="sidebar">
        <div class="shortcut-links">
            <a href="index.jsp" class="active"><i class="material-icons">home</i><span>Home</span></a>
            <a href="" data-toggle="modal" data-target="#loginModal"><i class="material-icons">videocam</i><span>Create channel</span></a>
            <a href="" data-toggle="modal" data-target="#loginModal"><i class="material-icons">library_add_check</i><span>Favourite</span></a>
            <a href="" data-toggle="modal" data-target="#loginModal"><i class="material-icons">history</i><span>History</span></a>
            <a href="" data-toggle="modal" data-target="#loginModal"><i class="material-icons">watch_later</i><span>Watch Later</span></a>
            <a href="" data-toggle="modal" data-target="#loginModal"><i class="material-icons">thumb_up</i><span>Liked Videos</span></a>
            <hr>
        </div>
        <div class="subscribed-list">
            <h3>SUGGESTED</h3>
            <%
                Statement stch=cn.createStatement();
                ResultSet rsch=stch.executeQuery("select * from channel limit 5");
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
    <!-------Login Modal------->
    <div class="container">
        <div class="modal fade" id="loginModal">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <!-- Modal Header -->
                    <div class="modal-header" style="background-color:#db4437">
                        <h4 class="modal-title" style="color:white">Login</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <!-- Modal body -->
                    <div class="modal-body">
                        <form action="check.jsp" method="post">
                            <div class="form-group">
                                Enter Email:<input type="email" name="email" class="form-control" placeholder="Enter Email...." required>
                            </div>
                            <div class="form-group">
                                Enter Password:<input type="password" name="pass" class="form-control" placeholder="Enter Password...." required>
                            </div>
                            <label>New user ?</label> <a id="signup_btn" data-dismiss="modal" style="color: blue; cursor: pointer">Sign-Up</a>
                            <button type="submit" class="btn vizew-btn w-100 mt-30">Login</button>
                        </form>
                    </div>
                    <!-- Modal footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-------Sign-Up Modal------->
        <div class="modal fade" role="dialog" id="signupModal" >
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <!-- Modal Header -->
                    <div class="modal-header" style="background-color:red ; color:white">
                      <h4 class="modal-title">Let's complete the Registration!</h4>
                      <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <!-- Modal body -->
                    <div class="modal-body">
                        <form action="register.jsp" method="post">
                            <div class="form-group">
                                Name*<input type="text" name="name" placeholder="Enter Name...." class="form-control" required>
                            </div>
                            <div class="form-group">
                                Email*<input type="text" name="email" placeholder="Enter Eamil...." class="form-control" required>
                            </div>
                            <div class="form-group">
                                Password*<input type="password" name="pass" placeholder="Enter Password...." class="form-control" required>
                            </div>
                            <label>Already have an account ?</label> <a id="login_btn" data-dismiss="modal" style="color: blue; cursor: pointer">login</a>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-danger form-control">Sign-Up</button>
                            </div>
                        </form>
                    </div>
                    <!-- Modal footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!------The Modal end-------->

    <div class="videos-container">
        <%
            int count=0, id=0, pages=0, start=0, total=8;
            if(request.getParameter("id")!=null){
                id=Integer.parseInt(request.getParameter("id"));
            }
            start=id*total;
            //counting total record
            Statement strec = cn.createStatement();
            ResultSet rsrec = strec.executeQuery("select count(*) from video where status=1");
            if(rsrec.next()){
                count=rsrec.getInt(1);
            }
            pages=(int)Math.ceil((double)count/total);
            if(id<0 || id>=pages){
                response.sendRedirect("index.jsp");
            }
            %>
            <div class="pagination" style="margin-left:500px">
                <%
                if(id>0){
                    %>
                    <a href="index.jsp?id=<%=id-1%>" style="margin-left:15px; text-decoration: underline"><button style="height:20px; border: none; color: black">Pre</button></a>
                    <%
                }
                for(int i=1; i<pages; i++){
                    %>
                    <a href="index.jsp?id=<%=i-1%>" style="margin-left:15px; text-decoration: underline"><button style="height:20px; border: none; color: black"><%=i%></button></a>
                    <%
                }
                if(id!=pages-1){
                    %>
                    <a href="index.jsp?id=<%=id+1%>" style="margin-left:15px; text-decoration: underline"><button style="height:20px; border: none; color: black">Next</button></a>
                    <%
                }
                %>
            </div>
        <div class="list-container">
            <%
                //taking videos of the channel from video table which have status as 1 (not deleted)
                Statement st = cn.createStatement();
                ResultSet rs = st.executeQuery("select * from video where status=1 order by sn desc limit "+start+","+total);
                while (rs.next()) {
                    //Taking video posting date
                    String postDate=rs.getString("dt");
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
                    //taking channel details
                    String channel_name="";
                    String channel_code="";
                    Statement stmt=cn.createStatement();
                    ResultSet rss=stmt.executeQuery("select * from channel where code IN(select ccode from video where code='"+rs.getString("code")+"')");
                    if(rss.next()){
                        channel_name=rss.getString("channel_name");
                        channel_code=rss.getString("code");
                    }
                    int views_count=0;
                        Statement st_vws=cn.createStatement();
                        ResultSet rs_vws=st_vws.executeQuery("select count(*) from views where videocode='"+rs.getString("code")+"'");
                        if(rs_vws.next()){
                            views_count=rs_vws.getInt(1);
                        }
                    %>
                    <div class="vid-list">
                        <a href="user_play_video.jsp?code=<%=rs.getString("code")%>"><img src="thumbnails/<%=rs.getString("code")%>.jpg" class="thumbnail" alt=""></a>
                        <div class="flex-div">
                            <img src="channel_profile/<%=channel_code%>.jpg">
                            <div class="vid-info">
                                <a href="user_play_video.jsp?code=<%=rs.getString("code")%>"><%=rs.getString("title")%></a>
                                <p><%=channel_name%></p>
                                <p><%=views_count%> Views &bull; <%=daysBtn%> days ago</p>
                            </div>
                        </div>
                    </div>
                    <%
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
    }
    catch(ClassNotFoundException e){
        e.printStackTrace();
    }
    catch(SQLException e){
        e.printStackTrace();
    }
    catch(NullPointerException e){
        e.printStackTrace();
    }
%>
