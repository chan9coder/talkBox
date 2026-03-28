<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
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

String pl_fname= "", pl_title = "", pl_content = "", pl_isview = "", pl_date= "";
int ai_idx =0, pl_read = 0;

try{
	stmt = conn.createStatement();
	sql = "update t_pds_list set pl_read = pl_read + 1 where pl_idx ="+idx;
	stmt.executeUpdate(sql);	// 조회수 증가 쿼리 실행
	
	sql = "select * from t_pds_list where pl_isview = 'y' and pl_idx=" + idx;
	rs = stmt.executeQuery(sql);
	if(rs.next()){
		pl_content=rs.getString("pl_content").replace("\r\n", "<br />");
		//엔터(\r\n)를 <br />태그로 변경하여 pl_content변수에 저장		
		pl_fname=rs.getString("pl_fname");		
		pl_title=rs.getString("pl_title");			
		pl_isview=rs.getString("pl_isview");
		pl_date=rs.getString("pl_date");
		ai_idx=rs.getInt("ai_idx");
		pl_read=rs.getInt("pl_read");
	} else {
		out.print("<script>");
		out.print("alert('존재하지 않는 게시물입니다.');");
		out.print("history.back();");
		out.print("</script>");
		out.close();	
	}
	
}catch(Exception e){
	out.println("자료실 글보기시 문제가 발생했습니다.");
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
<div id="listP">
<table width="600" cellpadding="5" id="viewSty" border="1">
	<h2 style="color:gray" >자료실</h2>
	
	<tr>
		<th>글 제목</th>
		<td width="15%"><%=pl_title %></td>
		<th>파일명</th>
		<td width="35%"><a href="tbAdminPDS_File_Download.jsp?file=<%=pl_fname  %>"><%=pl_fname %></a></td>
	</tr>
	<tr>
		<th width="15%">작성일</th>
		<td width="35%"><%=pl_date %></td>
		<th width="15%">조회수</th>
		<td width="35%"><%=pl_read %></td>
	</tr>
	<td colspan="4"style="border: 3px solid black;" height="400" valign="top"><%=pl_content%></td>
	</tr>
	
</table><br />
</div>
<div id="viewBtn0">
<table width="600" cellpadding="5" border="0">
<tr>
		<td colspan="2" align="center">
		<input type="button" class="btn2" value="수정" onclick="location.href='tbAdminPDSForm.jsp<%=args %>&kind=up&idx=<%=idx %>'" />
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
<script>
function isDel(){
	if(confirm("정말 삭제하시겠습니까?")){
		location.href ="tbAdminPDS_proc.jsp?kind=del&idx=<%=idx %>";
	}
}
</script> <input type="button" class="btn2" value="삭제" onclick="isDel();" />
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			<input type="button" class="btn2" value="목록" onclick="location.href='tbAdminPDSList.jsp<%=args %>'" /></td>
	</tr>
</table>
</div>
<%@ include file="../_inc/inc_foot.jsp"%>