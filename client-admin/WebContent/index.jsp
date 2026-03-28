<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="_inc/inc_head.jsp"%>
<%
if(isLogin){	//이미 로그인이 되어 있다면
	session.invalidate();
	response.sendRedirect("/talkboxAdmin/tbAdminLoginForm.jsp");
	
}
request.setCharacterEncoding("utf-8");
String url= request.getParameter("url");
if(url ==null)	url = ROOT_URL;
else			url = url.replace('~', '&');
%>
<style>
#loginf {
            margin: auto;
            width: 300px;
            background-color: white;
            border: 7px solid;
            border-color:gray;
            text-align: center;
            padding: 20px;
        }
 .btn1 {
  background-color: gray;
  border-radius: 10px;
  border: none;
  color: white;
  padding: 15px 100px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 22px;
  margin: 4px 2px;
  cursor: pointer;

}  
</style>

	<div id="loginf">
	<img alt="banner" src="./img/talkbox.png" onclick="location.href='/talkboxAdmin/tbAdminMain.jsp'" style="cursor:pointer;">
		<form name="frmLogin" action="/talkboxAdmin/login_pro_in.jsp" method="post"><br />
				<input type="hidden" name="url" value="<%=url%>" /> 
				&nbsp;관리자&nbsp;&nbsp; <input type="text" name="ai_id" placeholder="아이디 입력" value="admin" /><br />
				비밀번호 <input type="password" name="ai_pw" placeholder="비밀번호 입력" value="1234" />
				<br /><br />
			 <input type="submit" class="btn1" value="로그인" /> 
		</form>

	</div>

<%@ include file="_inc/inc_foot.jsp"%>