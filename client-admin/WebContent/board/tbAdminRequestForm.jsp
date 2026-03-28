<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String action = "tbAdminRequestProc.jsp";
String rc_name = "", rl_name = "", rl_use = "",rl_tname = "", rl_mem = "", rl_isreply = "", rl_replymem = "";
int rl_idx = Integer.parseInt(request.getParameter("idx"));

int rc_idx = 0;
try {
	stmt = conn.createStatement();
	sql = "select rc_idx from t_req_list where rl_idx = " + rl_idx;
	rs = stmt.executeQuery(sql);
	if (rs.next()) rc_idx = rs.getInt("rc_idx");
	
	sql = "select rc_name from t_req_ctgr where rc_idx = " + rc_idx;
	rs = stmt.executeQuery(sql);
	if(rs.next()) rc_name = rs.getString("rc_name");

} catch (Exception e){ e.printStackTrace();}

try{
	stmt = conn.createStatement();
	sql = "select * from t_req_list where rl_idx = " + rl_idx;
	
	rs = stmt.executeQuery(sql);
	if (rs.next()){
		rl_name = rs.getString("rl_name");
		rl_use = rs.getString("rl_use");
		rl_tname = rs.getString("rl_tname");
		rl_isreply = rs.getString("rl_isreply");
		rl_replymem = rs.getString("rl_replymem");
		rl_mem = rs.getString("rl_mem");
		
		if(rl_mem.equals("y")) rl_mem = "회원";
		else rl_mem = "비회원";
		
		if (rl_isreply.equals("y")) rl_isreply = "사용";
		else rl_isreply = "미사용";
	
		if (rl_replymem.equals("y")) rl_replymem = "회원";
		else rl_replymem = "비회원";
	}
}catch (Exception e){ e.printStackTrace(); }

%>
<div id="listP0" align="center">
<h2 align="center"><%=rl_name %>게시판 처리폼</h2>
</div>
<form name="frm" action="<%=action%>?rlidx=<%=rl_idx %>" method="post">
<div id="listP1" align="center">
<table width="700" cellpadding="5">
<tr><th width="15%">분류</th><td width="35%"><%=rc_name %></td></tr>
<tr><th width="15%">게시판 이름</th><td width="35%"><%=rl_name %></td></tr>
<tr><th width="15%">용도</th><td width="35%"><%=rl_use %></td></tr>
<tr><th width="15%">회원전용</th><td width="35%"><%=rl_mem %></td></tr>
<tr><th width="15%">댓글</th><td width="35%"><%=rl_isreply %>-<%=rl_replymem %></td></tr>
<tr><th width="15%">Table</th><td width="35%" valign="top"><input type="text" name="rltname"></td></tr>
<tr><th width="15%">반려사유</th><td width="35%" valign="top"><input type="text" name="rlreject"></td></tr>
</table>
</div>
<div id="listP2" align="center">
<table width="700" cellpadding="5">
<tr><td colspan="3" align="center">
	<input type="submit" class="btn2" name="reqstatus" value="승인"/>&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="submit" class="btn2" name="reqstatus" value="반려"/>&nbsp;&nbsp;&nbsp;&nbsp;
</td></tr>
</table>
</div>
</form>


<%@ include file="../_inc/inc_foot.jsp" %>