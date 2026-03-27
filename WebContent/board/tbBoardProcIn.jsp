<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%@ include file="../_inc/incReqList.jsp" %>
<!-- 해당 ??게시판에 게시글 등록을 처리하는 파일 -->
<%
request.setCharacterEncoding("utf-8");
String sl_ismem = "n";
// System.out.println(rl_name);
String sl_writer = getRequest(request.getParameter("sl_writer"));
String sl_pw = getRequest(request.getParameter("sl_pw"));
String sl_title = getRequest(request.getParameter("sl_title"));
String sl_content = getRequest(request.getParameter("sl_content"));
System.out.println(sl_writer);
System.out.println(sl_pw);
System.out.println(sl_title);
System.out.println(sl_content);

if (isLogin){
	sl_ismem = "y";
	sl_writer = loginInfo.getMi_id();
} else {
	sl_writer = getRequest(sl_writer);
	sl_pw = getRequest(sl_pw);
}

try {
	stmt = conn.createStatement();
	int sl_idx = 1;
	sql = "select max(sl_idx) + 1 from t_"+ rl_tname +"_list where rl_idx = " + rl_idx;
	System.out.println(sql);
	rs = stmt.executeQuery(sql);
	if (rs.next()) sl_idx = rs.getInt(1);

	sql = "insert into t_"+ rl_tname +"_list(sl_idx, rl_idx, sl_writer, sl_pw, sl_title, sl_content, sl_ismem) " + 
			" values("+ sl_idx +", "+ rl_idx +", '"+ sl_writer +"', '"+ sl_pw +"', '"+ sl_title +"', '"+ sl_content +"', '"+ sl_ismem +"')";
	
	System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	if (result == 1){
		response.sendRedirect("tbBoardView.jsp?cpage=1&slidx="+ sl_idx +"&rlidx="+ rl_idx);
	} else {
		out.println("<script>");
		out.println("alert('글 등록에 실패하였습니다. \\n다시 시도하세요.'); history.back();");
		out.println("</script>");
		out.close();
	}
} catch (Exception e){
	out.println("게시글 등록시 문제가 발생하였습니다.");
	e.printStackTrace();
} finally {
	try {
		rs.close();		stmt.close();
	}catch (Exception e) {
		e.printStackTrace();
	}
}
%>

<%@ include file="../_inc/inc_foot.jsp" %>