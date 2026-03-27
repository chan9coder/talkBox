<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%@ include file="../_inc/incReqList.jsp" %>
<%
request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int sl_idx = Integer.parseInt(request.getParameter("slidx"));
String args = "?cpage="+ cpage +"&slidx="+ sl_idx +"&rlidx="+ rl_idx;
String sl_pw = request.getParameter("sl_pw");
String sl_title = getRequest(request.getParameter("sl_title"));
String sl_content = getRequest(request.getParameter("sl_content"));
String where = " where sl_idx = "+ sl_idx + " and rl_idx = "+ rl_idx;

try {
	stmt = conn.createStatement();	
	sql = "update t_"+ rl_tname +"_list set " + "sl_title = '" + sl_title + "', sl_content = '" + sl_content + "' " + where;
	System.out.println(sql);
	stmt.executeUpdate(sql);
		out.println("<script>");
		out.println("location.replace('tbBoardView.jsp" + args + "');");
		out.println("</script>");
	
} catch (Exception e){
	out.println("게시글 수정시 문제가 발생하였습니다.");
	e.printStackTrace();
} finally {
	try {
		stmt.close();
	}catch (Exception e) {
		e.printStackTrace();
	}
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>