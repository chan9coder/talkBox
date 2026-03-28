<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
String kind =request.getParameter("kind");
%>
<style>
.img1 { width:300px; padding:10px; }
#idpwform{
            margin: auto;
            width: 300px;
            height: 180px;
            background-color: white;
            border: 3px solid;
            border-color:green;
            text-align: center;
            padding: 20px;
        }
.btn1 {
  background-color: green;
  border: 1px solid;
  border-color:yellowgreen;
  color: white;
  padding: 10px 50px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 12px;
  margin: 4px 2px;
  cursor: pointer;

}  
</style>
<div align="center">
<br />
<%if(kind.equals("id")) {%>
	<img alt="아이디 찾기" class="img1" src="/talkbox/img/id_c.png" onclick="location.href='/talkbox/member/tbMemSearch.jsp?kind=id'" style="cursor:pointer;">
	<img alt="비밀번호 찾기" class="img1" src="/talkbox/img/pw.png" onclick="location.href='/talkbox/member/tbMemSearch.jsp?kind=pw'" style="cursor:pointer;">
<%} else { %>
	<img alt="아이디 찾기" class="img1" src="/talkbox/img/id.png" onclick="location.href='/talkbox/member/tbMemSearch.jsp?kind=id'" style="cursor:pointer;">
	<img alt="비밀번호 찾기" class="img1" src="/talkbox/img/pw_c.png" onclick="location.href='/talkbox/member/tbMemSearch.jsp?kind=pw'" style="cursor:pointer;">
<%} %>
</div>
<br /><br />
<div id="idpwform" >
<form name="frmJoin" action= "/talkbox/mailsendproc" method="post" >

<%if(kind.equals("id")) {%>
<label >아이디 찾기</label><br /><br />
<div align="left"style="border:none;">
	
&nbsp;이름&nbsp;&nbsp;<input type="text" name="mi_name" size="10"/><br /><br />
Email&nbsp;<input type="text" maxlength="20" size="10" name="em1"/>
@<input size="10" type="text" name="em2"/><br /><br />

	
</div>
<input type="submit" class="btn1" value="아이디 찾기" />
<%} else {
%>
<label >비밀번호 찾기</label><br /><br />
<div align="left"style="border:none;">
	
&nbsp;&nbsp;&nbsp;ID&nbsp;&nbsp;<input type="text" name="mi_id" size="10"/><br /><br />
Email&nbsp;<input type="text" maxlength="20" size="10" name="em1"/>
@<input size="10" type="text" name="em2"/><br /><br />
</div>
<input type="submit" class="btn1" value="비밀번호 찾기" />
<%} %>
</div>
<input type="hidden" name="kind" value="<%=kind %>" />

</form>
</div>
<%@ include file="../_inc/inc_foot.jsp"%>