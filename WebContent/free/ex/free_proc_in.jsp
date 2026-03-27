<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
String fl_ismem = "n";
String fl_writer = request.getParameter("fl_writer");
String fl_pw = request.getParameter("fl_pw");
String fl_title= getRequest(request.getParameter("fl_title"));
String fl_content= getRequest(request.getParameter("fl_content"));
String fl_ip= request.getRemoteAddr();

if (isLogin){
	fl_ismem = "y";
	fl_writer = loginInfo.getMi_id();
	
} else {
	fl_writer =getRequest(fl_writer);
	fl_pw = getRequest(fl_pw);
}

try {
	stmt =conn.createStatement();
	int idx =1;
	sql ="select max(fl_idx) + 1 from t_free_list";
	rs =stmt.executeQuery(sql);
	if(rs.next())	idx = rs.getInt(1);
	
	sql = "insert into t_free_list (fl_idx, fl_ismem, fl_writer, fl_pw, fl_title, fl_content, fl_ip) values (?, ?, ?, ?, ?, ?, ? )";
	PreparedStatement pstmt =conn.prepareStatement(sql);
	pstmt.setInt(1,idx);
	pstmt.setString(2,fl_ismem);
	pstmt.setString(3,fl_writer);
	pstmt.setString(4,fl_pw);
	pstmt.setString(5,fl_title);
	pstmt.setString(6,fl_content);
	pstmt.setString(7,fl_ip);
	
	int result = pstmt.executeUpdate();
	if (result == 1){
		response.sendRedirect("free_view.jsp?cpage=1&idx="+idx);
	} else {
		out.print("<script>");
		out.print("alert('게시 글 등록에 실패했습니다.\n다시 시도하세요.');");
		out.print("history.back();");
		out.print("</script>");
		out.close();
	}
	
	
} catch(Exception e){
	out.print("게시글 등록시 문제가 발생했습니다.");
	e.printStackTrace();
}
%>
<%@ include file="../_inc/inc_foot.jsp"%>