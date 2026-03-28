<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int rl_idx = Integer.parseInt(request.getParameter("idx"));
String schtype = request.getParameter("schtype");	// 검색조건
String keyword = request.getParameter("keyword");	// 검색어
String args = "?cpage=" + cpage;
if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")){
	args += "&schtype=" + schtype + "&keyword=" + keyword;
	// 링크에 검색 관련 값들을 쿼리스트링으로 연결해줌
}

// view 화면에서 보여줄 게시글의 정보들을 저장할 변수들
String rc_name = "", mi_id = "",rl_name = "", rl_tname = "", rl_use = "", rl_mem = "", rl_isreply="", rl_status = "", rl_reject = "", rl_replymem = "", rl_date = "";
int rc_idx = 0;
try {
	stmt = conn.createStatement();
	sql = "select rc_idx from t_req_list where rl_idx = " + rl_idx;
	rs = stmt.executeQuery(sql);
	if (rs.next()) rc_idx = rs.getInt("rc_idx");
	
	sql = "select rc_name from t_req_ctgr where rc_idx = " + rc_idx;
	rs = stmt.executeQuery(sql);
	
	if(rs.next()) rc_name = rs.getString("rc_name");
} catch (Exception e){
	e.printStackTrace();
}

try {
	stmt = conn.createStatement();

	sql = "select * from t_req_list where rl_mem = 'y' and rl_idx = " + rl_idx;
	rs = stmt.executeQuery(sql);
	// System.out.println(sql);
	if (rs.next()){
		rl_name = rs.getString("rl_name");
		mi_id	= rs.getString("mi_id");
		rl_tname = rs.getString("rl_tname");
		rl_mem = rs.getString("rl_mem");
		rl_use = rs.getString("rl_use").replace("\r\n", "<br />");
		rl_isreply = rs.getString("rl_isreply");
		rl_replymem = rs.getString("rl_replymem");
		rl_status = rs.getString("rl_status");
		
		rl_reject = rs.getString("rl_reject");
		if (rl_reject == null) rl_reject = "";
		else {rl_reject.replace("\r\n", "<br />");}
	} else {
		out.println("<script>");
		out.println("alert('존재하지 않는 게시물입니다.'); history.back();");
		out.println("</script>");
		out.close();
	}
	//System.out.println(sql);
	
} catch (Exception e){
	out.println("게시글 글보기시 문제가 발생하였습니다.");
	e.printStackTrace();
}
if (rl_mem.equals("y"))  rl_mem = "회원";
else rl_mem = "비회원";

if (rl_isreply.equals("y"))  rl_isreply = "사용";
else rl_isreply = "미사용";

if (rl_replymem.equals("y"))  rl_replymem = "회원";
else rl_replymem = "비회원";

if (rl_status.equals("a"))  rl_status = "일반회원";
else if (rl_status.equals("b")) rl_status = "탈퇴회원";
else rl_status = "휴면회원";
%>
<style>
.info{ background-color:gray; }
</style>
<div id="listP">
<h2 align="center">게시판 요청 뷰</h2>
<table width="700" cellpadding="5" border="1" align="center">
<tr style="display:none;">
<th width="10%">작성자</th><td width="13%"><%=mi_id %></td>
</tr>
<tr><th class="info">분류</th><td colspan="2"><%=rc_name%></td><th class="info">게시판이름</th><td><%=rl_name %></td></tr>
<tr><th class="info">회원전용</th><td colspan="2"><%=rl_mem %></td><th class="info">댓글</th><td><%=rl_isreply %>-<%=rl_replymem %></td></tr>
<tr><th class="info">상태</th><td colspan="2"><%=rl_status %></td><th class="info">등록일</th><td><%=rs.getString("rl_date") %></td></tr>
<tr><th class="info">테이블명</th><td colspan="4"><%=rl_tname %></td></tr>
<tr><th class="info" height="50">용도</th><td colspan="4" height="50" valign="top"><%=rl_use %></td></tr>
<tr><th class="info" height="70">반려사유</th><td colspan="4" height="70" valign="top"><%=rl_reject %></td></tr>
</table>
<br />
<div style="text-align:right">
<input type="button" class="btn2"  value="목록" onclick="location.href='tbAdminRequestList.jsp'" />
</div>
</div>
<%@ include file="../_inc/inc_foot.jsp" %>

