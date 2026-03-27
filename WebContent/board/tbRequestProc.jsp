<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String rc_name = request.getParameter("rc_name");						// 분류 이름
String rl_name = request.getParameter("rl_name");						// 게시판 이름
String rl_use = request.getParameter("rl_use");							// 게시판 용도
String rl_mem = getRequest(request.getParameter("rl_mem"));				// 회원전용 여부
String rl_isreply = getRequest(request.getParameter("rl_isreply"));		// 댓글 사용여부
String rl_replymem = getRequest(request.getParameter("rl_replymem"));	// 댓글 사용 회원전용 여부
String rl_status = "c";					// 게시판 상태 여부
String mi_id = loginInfo.getMi_id();

try {
	stmt = conn.createStatement();
	sql = "select rc_idx from t_req_ctgr where rc_name = '" + rc_name + "' ";
	// System.out.println(sql);
	
	rs = stmt.executeQuery(sql);
	int rc_idx = 0;
	if (rs.next())	 rc_idx = rs.getInt("rc_idx");
	sql = "insert into t_req_list(rc_idx, rl_name, mi_id, rl_use, rl_mem, rl_isreply, rl_replymem, rl_status)" + 
			"value("+ rc_idx +", '"+ rl_name +"', '"+ mi_id +"','"+ rl_use +"', '"+ rl_mem +"', '"+ rl_isreply +"', '"+ rl_replymem +"', '"+ rl_status +"')";
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	if (result == 1){
		response.sendRedirect("../tbMain.jsp");
	} else {
		out.println("<script>");
		out.println("alert('게시판 요청에 실패하였습니다. \\n다시 시도하세요.'); history.back();");
		out.println("</script>");
		out.close();
	}
	
} catch (Exception e){
	out.println("게시판 요청시 문제가 발생하였습니다.");
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