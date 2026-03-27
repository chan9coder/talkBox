<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%

request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
String caption = "등록"; // 버튼에 사용할 캡션 문자열
String fl_writer = "", fl_pw = "", fl_title = "", fl_content = "", fl_isview = "n";

int idx =0;			// 글번호를 저장할 변수로 '수정'일 경우에만 사용됨
int cpage = 1;		// 페이지번호를 저장할 변수로 '수정'일 경우에만 사용됨
String schtype = request.getParameter("schtype");		// 검색조건
String keyword = request.getParameter("keyword");		// 검색어
String args = "";
if(!(schtype == null || schtype.equals("") || keyword == null || keyword.equals(""))){	//검색을 하지 않는 경우
	args += "&schtype="+ schtype + "&keyword=" + keyword;
}	//링크에 검색 관련 값들을 쿼리스트링으로 연결해줌

if(kind.equals("up")){	//공지글 수정 폼일 경우
	caption = "수정";
	cpage = Integer.parseInt(request.getParameter("cpage"));
	idx = Integer.parseInt(request.getParameter("idx"));
	try{
		stmt = conn.createStatement();
		sql = "select * from t_notice_list where fl_isview = 'y' and fl_idx=" + idx;
		rs = stmt.executeQuery(sql);
		if(rs.next()){
			fl_content=rs.getString("fl_content");
			fl_writer=rs.getString("fl_writer");
			fl_title=rs.getString("fl_title");		
			fl_isview=rs.getString("fl_isview");
		} else {
			out.print("<script>");
			out.print("alert('존재하지 않는 게시물입니다.');");
			out.print("history.back();");
			out.print("</script>");
			out.close();	
		}
		
	}catch(Exception e){
		out.println("자유게시판 글수정폼에서 문제가 발생했습니다.");
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

<div align="center">
<form name="frm" action="/talkbox/free/tbfreeProc.jsp" method="post">
	<input type="hidden" name="kind" value="<%=kind %>" />
	<input type="hidden" name="caption" value="<%=caption%>" />
	<%if (kind.equals("up")) {%>
	<input type="hidden" name="idx" value="<%=idx%>" /> <input
		type="hidden" name="cpage" value="<%=cpage%>" />
	<%	if(!(schtype == null || schtype.equals("") || keyword == null || keyword.equals(""))) { %>
	<input type="hidden" name="schtype" value="<%=schtype%>" /> <input
		type="hidden" name="keyword" value="<%=keyword%>" />
	<%
	} 
}
%>
<style>
#freeform{
	display: inline-block;
	position: absolute; left: 660px; top: 250px;
	border:none;
}
#threebtn{
	display: inline-block;
	position: absolute; left: 530px; top: 500px;
	border:none;
}
#freecaption{
	display: inline-block;
	position: absolute; left: 300px; top: 150px;
	border:none;
}

</style>
<div id="freecaption">
<table width="1000" cellpadding="5" >
<td align="center"><h2>자유게시판 <%=caption %></h2></td>
</table>
</div>
<div id=freeform>
<table width="1000" cellpadding="5" id="tbfree">
	<tr>
		<th width="15%">작성자</th>
		<%//if(fl_writer.equals(loginInfo.getMi_id()))  {
		if(isLogin) {%>
		<td width="*"><label><%=loginInfo.getMi_id() %></label>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
		<%} else { %>
		<td width="*"><input type="text" name="fl_writer" size="10" maxlength="100" value='<%=fl_writer %>' />
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		비밀번호 &nbsp;&nbsp;&nbsp;<input type="password" name="fl_pw" size="10" maxlength="100" value='<%=fl_pw %>' /></td>
		<%} %>
		
	</tr>
	<tr>
		<th width="15%">글제목</th>
		<td width="*"><input type="text" name="fl_title" size="63" maxlength="100" value='<%=fl_title %>' />

		</td>
	</tr>
	<tr>
		<th>글 내용</th>
		<td><textarea name="fl_content" rows="10" cols="65" maxlength="500"><%=fl_content %></textarea>
			
	</tr>
	
</table>
</div>
<div id="threebtn">
<table width="1000" cellpadding="5" >
<tr>
	<td align="center">
	<input type="submit" class="btn2" value="<%=caption %>" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
	<input type="reset" class="btn2" value="다시 입력" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
	<input type="button" class="btn2" value="목록" onclick="location.href='tbfreeList.jsp?cpage=<%=cpage + args%>';" />
	</td>
</tr>
</table>
</div>

</form>
</div>
<%@ include file="../_inc/inc_foot.jsp"%>