<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
int cpage = 1, psize = 3, bsize = 5, rcnt = 0, pcnt = 0;

if (request.getParameter("cpage") != null) 
	cpage = Integer.parseInt(request.getParameter("cpage"));

String schtype = request.getParameter("schtype");	// 검색조건
String keyword = request.getParameter("keyword");	// 검색어
String schargs = "";	// 검색관련 쿼리스트링을 저장할 변수
String where = " where nl_isview = 'y' ";	

if (schtype == null || schtype.equals("") || keyword == null || keyword.equals("")) {	// 검색을 하지 않는 경우
	schtype = "";	keyword = "";
} else {
	keyword = getRequest(keyword);
	URLEncoder.encode(keyword, "UTF-8");
	// 쿼리스트링으로 주고 받는 검색어가 한글일 경우 IE에서 문제가 발생할 수도 있으므로 유니코드로 변환
	
	if (schtype.equals("tc")) {	// 검색조건이 '제목+내용'일 경우
		where += " and (nl_title like '%" + keyword + "%' or nl_content like '%" + keyword + "%') ";
	} else {	// 검색조건이 '제목'이거나 '내용'일 경우
		where += " and nl_" + schtype + " like '%" + keyword + "%' ";	// 검색어가 포함된 글 찾음  / % : 앞이나 뒤에 뭐가 있든 keyword가 있는 글을 찾아라
	}
	schargs = "&schtype=" + schtype + "&keyword=" + keyword;
	// 검색조건이 있을 경우 링크의 url에 붙일 쿼리스트링 완성
}


try{
	stmt = conn.createStatement();
	
	sql = "select count(*) from t_notice_list" + where;
	// 검색된 레코드의 총 개수를 구하는 쿼리 : 페이지 개수를 구하기 위해
	rs = stmt.executeQuery(sql);
	if (rs.next())	rcnt = rs.getInt(1);
	// count() 함수를 사용하므로 ResultSet 안의 데이터 유무를 검사할 필요는 없음
	
	pcnt = rcnt / psize;
	if (rcnt % psize > 0)	pcnt++;	// 전체 페이지 수
	
	int start = (cpage - 1) * psize;
	sql = "select nl_idx, nl_ctgr, nl_title, nl_read, if(curdate() = date(nl_date), time(nl_date), replace(mid(nl_date, 3, 8), '-', '.')) nldate " +
		" from t_notice_list " + where + " order by nl_idx desc limit " + start + ", " + psize;
	//System.out.println(sql);
	rs = stmt.executeQuery(sql);

	
	stmt = conn.createStatement();
	
	sql="select count(mi_id) cnt,mi_id, mi_name, mi_phone, mi_email, left(mi_date, 10) date, "+
			"if(mi_status = 'a', '정상회원', if(mi_status = 'b', '휴면회원', '탈퇴회원')) status from t_member_info group by mi_id";
	System.out.println(sql);
	rs =stmt.executeQuery(sql);
	
}catch(Exception e){
	e.printStackTrace();
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Document</title>
<style>
div {border:1px solid black;}
#id1 {  width:1300px; height:800px;}
.id2 {  display: inline-block;width:500px; height:500px;float:left;}
</style>
</head>
<body>
<div id="id1">
	<div class="id2">
		<div style="width:200px; height:100px;margin:10px">sss</div>
		<div style="width:200px; height:300px;margin:10px">sss</div>
	</div>	
	<div class="id2"style="text-align:center;">
		<div style=" display:inline-block; margin:10px ">
			<select name="schtype">
				<option value="">아이디</option>
				<option value="">이름</option>
				<option value="">이메일</option>
				<option value="">전화번호</option>
			</select>
			<input type="text" name="keyword" value="">
			<input type="button" name="submit" value="검색">&nbsp;&nbsp;&nbsp;
			<input type="button" value="전체 검색" onclick="location.href='tbAdminMemInfo.jsp'">
		</div>
		<div>
		<table border="1">
	<tr>
	<th>번호</th><th>아이디</th><th>이름</th><th>이메일</th><th>전화번호</th><th>가입일자</th><th>상태</th>
	</tr>

<%	if(rs.next()){
	do{
		
		%>
		<tr>
		<td><%=rs.getInt("cnt") %></td>
		<td><%=rs.getString("mi_id") %></td>
		<td><%=rs.getString("mi_name") %></td>
		<td><%=rs.getString("mi_phone") %></td>
		<td><%=rs.getString("mi_email") %></td>
		<td><%=rs.getString("date") %></td>
		<td><%=rs.getString("status") %></td>
		</tr>
		<%
	}while(rs.next());
}
%>
</table>
		</div>
	</div>
</div>

<%@ include file="_inc/inc_foot.jsp" %>