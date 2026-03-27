<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
String caption = "등록"; // 버튼에 사용할 캡션 문자열
String action = "free_proc_in.jsp";
String fl_writer ="",fl_date = "", fl_title ="",fl_content ="";

int idx =0;	
int cpage = 1;	
String schtype = request.getParameter("schtype");
String keyword = request.getParameter("keyword");
String args = "";
// if(schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")){
if(!(schtype == null || schtype.equals("") || keyword == null || keyword.equals(""))){
	args += "&schtype="+ schtype + "&keyword=" + keyword;
}
String fl_ismem = request.getParameter("fl_ismem");
//현재 수정상태이면서 해당 글이 비회원 글일 경우에만 'n'의 값이 있음
if(fl_ismem == null)	fl_ismem = "y";
String fl_pw = request.getParameter("fl_pw");
if(kind.equals("up")){		//게시글 수정 폼일 경우
	caption = "수정";
	action = "free_proc_up.jsp";
	
	idx = Integer.parseInt(request.getParameter("idx"));
	cpage = Integer.parseInt(request.getParameter("cpage"));
	String where =" where fl_isview = 'y' and fl_idx = "+ idx + " and fl_ismem = '"+ fl_ismem +"' ";
	if(fl_ismem.equals("n"))	//비회원글일 경우
		where+=" and fl_pw = '"+ fl_pw + "' ";
	else	//회원글일 경우
		where+=" and fl_writer = '" + loginInfo.getMi_id() +"' ";
	sql = "select * from t_free_list "+ where;
	try{
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
		if(rs.next()){	// 게시글이 있으면
			fl_writer = rs.getString("fl_writer");
			fl_date = rs.getString("fl_date");
			fl_title = rs.getString("fl_title");
			fl_content = rs.getString("fl_content");
		
		} else {	// 게시글이 없으면
			out.print("<script>");
			if(fl_ismem.equals("n"))
				out.print("alert('암호가 틀렸습니다.\\n다시 시도하세요.');");
			else
				out.print("alert('잘못된 경로로 들어오셨습니다.');");
			out.print("history.back();");
			out.print("</script>");
			out.close();	
		}
		
	}catch(Exception e){
		out.println("게시글 수정폼에서 문제가 발생했습니다.");
		e.printStackTrace();
	}finally{
		try{
			rs.close();
			stmt.close();
		} catch(Exception e){
			e.printStackTrace();
		}
	}
}
%>
<h2>
	자유게시판
	<%=caption %>
	폼
</h2>
<form name="frm" action="<%=action %>" method="post">
	<% if (kind.equals("up")) {%>
	<input type="hidden" name="idx" value="<%=idx %>" /> <input
		type="hidden" name="cpage" value="<%=cpage %>" /> <input
		type="hidden" name="fl_pw" value="<%=fl_pw %>" /> <input
		type="hidden" name="fl_ismem" value="<%=fl_ismem %>" />

	<% if(!(schtype == null || schtype.equals("") || keyword == null || keyword.equals(""))) {%>
	<input type="hidden" name="schtype" value="<%=schtype %>" /> <input
		type="hidden" name="keyword" value="<%=keyword %>" />
	<%
	} 
} 
%>
	<table width="700" cellpadding="5">
		<tr>
			<%

if(kind.equals("in")) {
	if(isLogin) {%>
			<th width="15%">작성자</th>
			<td width="35%"><%=loginInfo.getMi_id() %></td>
			<th width="15%">작성일</th>
			<td width="35%"><%=LocalDateTime.now() %></td>
			<%} else {%>
			<th width="15%">작성자</th>
			<td width="35%"><input type="text" name="fl_writer" /></td>
			<th width="15%">비밀번호</th>
			<td width="35%"><input type="password" name="fl_pw" /></td>
			<%
	}
}else { %>
			<th width="15%">작성자</th>
			<td width="35%"><%=fl_writer %></td>
			<th width="15%">작성일</th>
			<td width="35%"><%=fl_date %></td>
			<%} %>
		</tr>
		<tr>
			<th>글제목</th>
			<td width="35%" colspan="3"><input type="text" name="fl_title"
				size="60" value="<%=fl_title %>" /></td>
		</tr>
		<tr>
			<th>글내용</th>
			<td colspan="3"><textarea name="fl_content" cols="65" rows="10"><%=fl_content %></textarea></td>
		</tr>
		<tr>
			<td colspan="4" align="center"><input type="submit"
				value="글<%=caption %>" />&nbsp;&nbsp;&nbsp;&nbsp; <input
				type="reset" value="다시 입력" />&nbsp;&nbsp;&nbsp;&nbsp; <input
				type="button" value="글목록"
				onclick="location.href='free_list.jsp?cpage=<%=cpage + args %>';" />
			</td>
		</tr>
	</table>
</form>
<%@ include file="../_inc/inc_foot.jsp"%>