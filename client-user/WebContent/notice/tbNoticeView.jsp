<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage")); 
int idx = Integer.parseInt(request.getParameter("idx"));
String schtype = request.getParameter("schtype");		// 검색조건
String keyword = request.getParameter("keyword");		// 검색어
String args = "?cpage="+cpage;
if(!(schtype == null || schtype.equals("") || keyword == null || keyword.equals(""))){	//검색을 하지 않는 경우
	args += "&schtype="+ schtype + "&keyword=" + keyword;
}	//링크에 검색 관련 값들을 쿼리스트링으로 연결해줌

String nl_ctgr = "", nl_title = "", nl_content = "", nl_isview = "", nl_date= "";
int ai_idx =0, nl_read = 0;

try{
	stmt = conn.createStatement();
	sql = "update t_notice_list set nl_read = nl_read + 1 where nl_idx ="+idx;
	stmt.executeUpdate(sql);	// 조회수 증가 쿼리 실행
	
	sql = "select * from t_notice_list where nl_isview = 'y' and nl_idx=" + idx;
	rs = stmt.executeQuery(sql);
	if(rs.next()){
		nl_content=rs.getString("nl_content").replace("\r\n", "<br />");
		//엔터(\r\n)를 <br />태그로 변경하여 nl_content변수에 저장
		nl_ctgr=rs.getString("nl_ctgr");
		nl_title=rs.getString("nl_title");		
		nl_isview=rs.getString("nl_isview");
		nl_date=rs.getString("nl_date");
		ai_idx=rs.getInt("ai_idx");
		nl_read=rs.getInt("nl_read");
	} else {
		out.print("<script>");
		out.print("alert('존재하지 않는 게시물입니다.');");
		out.print("history.back();");
		out.print("</script>");
		out.close();	
	}
	
}catch(Exception e){
	out.println("공지사항 글보기시 문제가 발생했습니다.");
	e.printStackTrace();
}finally{
	try{
		rs.close();
		stmt.close();
	} catch(Exception e){
		e.printStackTrace();
	}
}
%>
<div align="center">
<table width="800">
<td align="left"><h2>공지사항 글</h2></td>
</table>
<table width="800" cellpadding="5" border="1" id="TBView">
	<tr>
		<th>글 제목</th>
		<td colspan="3">[<%=nl_ctgr %>]<%=nl_title %></td>
	</tr>
	<tr>
		<th width="15%">작성일</th>
		<td width="35%"><%=nl_date %></td>
		<th width="15%">조회수</th>
		<td width="35%"><%=nl_read %></td>
	</tr>
	<td colspan="4" height="400" style="border:3px solid black;"  valign="top"><%=nl_content%></td>
	</tr>
</table>
<table width="800">
<td align="right"><input type="button" class="btn1" align="right" value="목록" onclick="location.href='tbNoticeList.jsp<%=args %>'" /></td>
</table>
</div>
<%@ include file="../_inc/inc_foot.jsp"%>