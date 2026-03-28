<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.time.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>

<%!   //공용으로 사용할 메소드 선언 및 정의 영역
public String getRequest(String req){
   if(req!=null){
      return req.trim().replace("<", "&lt;");   
   }
   return"";
}
%>
<%
//---------------------dB------------------------------------------
String driver = "com.mysql.cj.jdbc.Driver";
String dburl = "jdbc:mysql://localhost:3306/talkbox?useUnicode=true&" + 
   "characterEncoding=UTF8&verifyServerCertificate=false&" + 
   "useSSL=false&serverTimezone=UTC";
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
String sql = null;
try {
   Class.forName(driver);
   conn = DriverManager.getConnection(dburl, "root", "1234");

} catch(Exception e) {
   out.println("DB연결에 문제가 발생했습니다.");
   e.printStackTrace();
}
//-----------------------------------------------------------------
final String ROOT_URL = "/talkboxAdmin/";

boolean isLogin = false;
AdminInfo loginInfo = (AdminInfo)session.getAttribute("loginInfo");
if(loginInfo!= null) isLogin = true;
String loginUrl = request.getRequestURI();
if(request.getQueryString() != null) loginUrl+="?"+ URLEncoder.encode(request.getQueryString().replace('&','~'),"UTF-8");
//현재 화면의 url로 로그인 폼 등에서 사용할 값

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.talk_bar {
   
    background-color: #E2E2E2;
    border-width: 3px 0 1px 0;
    height:50px;
}
a:link {
   color: black;
   text-decoration: none;
}

a:vistited {
   color: gray;
   text-decoration: none;
}

a:hover {
   color: gray;
   text-decoration: underline;
}
#MemForm{
	border-top: solid gray 3px;
   border-bottom: solid gray 2px;
}
#list th, #list td {
   padding: 8px 3px;
}

#list th {
   border-top: solid gray 3px;
   border-bottom: solid gray 2px;
}

#list td {
   border-bottom: double gray 1px;
}
/*-------------------------  */
#listP{
	display: inline-block;
	position: absolute; left: 700px; top: 150px;
}
#listnum{
	display: inline-block;
	position: absolute; left: 280px; top: 720px;
}
#formBtn {
    display: inline-block;
    position: absolute;
    left: 120px;
    top: 470px;
}

#viewBtn {
    display: inline-block;
    position: absolute;
    left: 900px;
    top: 750px;
    border:none;
}
#viewBtn0 {
    display: inline-block;
    position: absolute;
    left: 700px;
    top: 750px;
    border:none;
}
#viewSty{
	border-collapse: collapse;
	border: 3px solid black;
}
#viewSty th{
	background :gray;
}
#listP0{
	display: inline-block;
	position: absolute; left: 830px; top: 150px;
}
#listP1{
	display: inline-block;
	position: absolute; left: 700px; top: 230px;
}#listP2{
	display: inline-block;
	position: absolute; left: 610px; top: 500px;
}
/*-------------------------  */
.hand{ cursor:pointer; }
#logBlock {
      margin: auto;
      width: 300px;
      background-color: #EEEFF1;
      border-radius: 5px;
      text-align: center;
      padding: 20px;
        }
.btn1 {
  background-color: #a0a0a0;
  border: none;
  color: white;
  padding: 15px 100px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;

} 
.btn2{
  background-color:gray;
  border: 1px solid black;
  color: white;
  padding: 5px 9px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 14px;
  margin: 0 0;
  cursor: pointer;
}     
.disable {
   color: gray;
}
</style>
</head>
<body>
<%if(isLogin) {%>
<div id="wrap">
   <div id="header">
      <div id="logo">
               
      <%if(isLogin) {%>
        <a href="<%=ROOT_URL %>/tbAdminMemInfo.jsp"><img src="/talkboxAdmin/img/logo.png" alt="logo"></a>
      <%} %>
   </div>
       <div>
           <div class="talk_bar"></div>
        </div>        
   </div> 
            <!-- menubar -->

   <div id="main" style="padding:10px;">
      <div id="left" style="display:inline-block;">
         <div>
            <div>
               <div class="block">
               <table>
               <%if(isLogin) {%> 
               	<tr><td><%=loginInfo.getAi_name() %>님 환영합니다.</td></tr>
                  <tr><td align="center"><a href="index.jsp"><img src="/talkboxAdmin/img/logout.png" alt="logo"></a></td></tr>
              <%}else{ %>
                 <tr><td align="center"><a href="index.jsp"><img src="/talkboxAdmin/img/login.png" alt="logo"></a></td></tr>            
               <%} %>
            
               </table>
               </div>
               <table id="list">
                  <tr><th>메뉴</th></tr>
                  <tr><td><a href="/talkboxAdmin/tbAdminMemInfo.jsp">전체회원관리</a></td></tr>
                  <tr><td><a href="/talkboxAdmin/notice/tbAdminNoticeList.jsp">공지사항 관리</a></td></tr>
                  <tr><td><a href="/talkboxAdmin/free/tbAdminfreeList.jsp" >자유게시판 관리</a></td></tr>
                 <!--  <tr><td><a >게시판 관리</a></td></tr> -->
                  <tr><td><a href="/talkboxAdmin/board/tbAdminRequestList.jsp">게시판 요청 관리</a></td></tr>
                  <tr><td><a class="disable">Q&A 관리</a></td></tr>
                  <tr><td><a href="/talkboxAdmin/pbs/tbAdminPDSList.jsp">자료실 관리</a></td></tr>
               </table>
            </div>
         </div>
      </div>

<%} else {%>
<a href="/talkboxAdmin/index.jsp"><img src="/talkboxAdmin/img/logo.png" alt="logo"></a>
<%} %>