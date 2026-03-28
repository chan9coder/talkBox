<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="_inc/inc_head.jsp"%>


<%
if (isLogin) {%>
<%=loginInfo.getAi_id() %>(<%=loginInfo.getAi_name() %>)님 환영합니다.
<br />
<a href="tbAdminLogout.jsp">로그아웃</a>
<%} else {%>
<a href="tbAdminLoginForm.jsp">로그인</a><br />
<%} %>
<br />
<hr />
<a href="notice/tbAdminNoticeList.jsp">공지사항</a>
<br />
<hr />
<a href="pbs/tbAdminPDSList.jsp">자료실</a>
<%@ include file="_inc/inc_foot.jsp"%>