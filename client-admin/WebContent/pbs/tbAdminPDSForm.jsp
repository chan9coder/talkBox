<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
System.out.print("tbAdminpdsForm");
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
String caption = "등록"; // 버튼에 사용할 캡션 문자열
String action = "tbAdminPDS_proc.jsp";
String pl_fname = "", pl_title = "", pl_content = "", pl_isview = "n"; 
String ai_idx = loginInfo.getAi_idx();

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
	//System.out.println("ai_idx: "+ai_idx);
	try{
		stmt = conn.createStatement();
		sql = "select * from t_pds_list where pl_isview = 'y' and pl_idx=" + idx;
		rs = stmt.executeQuery(sql);
		if(rs.next()){
			
			pl_content=rs.getString("pl_content");
			pl_fname=rs.getString("pl_fname");
			pl_title=rs.getString("pl_title");		
			pl_isview=rs.getString("pl_isview");
		} else {
			out.print("<script>");
			out.print("alert('존재하지 않는 게시물입니다.');");
			out.print("history.back();");
			out.print("</script>");
			out.close();	
		}
		
	}catch(Exception e){
		out.println("자료실 글수정폼에서 문제가 발생했습니다.");
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

	
<form action="/talkboxAdmin/uploadfileproc" method="post" enctype="multipart/form-data">
<!-- <form name="frm" action="<%=action %>" method="post"> -->
	<%if (kind.equals("up")) {%>
	<input type="hidden" name="idx" value="<%=idx%>" /> 
	<input type="hidden" name="cpage" value="<%=cpage%>" />
	<%	if(!(schtype == null || schtype.equals("") || keyword == null || keyword.equals(""))) { %>
	<input type="hidden" name="schtype" value="<%=schtype%>" /> 
	<input type="hidden" name="keyword" value="<%=keyword%>" />
	<%
	} 
}
	
%>	
	<div id="listP">
	<h2>자료실 글<%=caption %></h2><br />
	<table width="600" cellpadding="5">
		<tr>
			<th width="15%">글제목</th>
			<td width="*">
			<input type="text" name="pl_title" size="49"  maxlength="100" value='<%=pl_title %>' />
			<input type="hidden" name="kind" value="<%=kind%>" />
			<input type="hidden" name="ai_idx" value="<%=ai_idx%>" />
			<input type="hidden" name="caption" value="<%=caption%>" />
			</td>
		</tr>
		<tr>
			<th width="15%">파일</th>
			<td width="*">
			<input type="file" name="file" size="49" value='<%=pl_fname %>' />
			<%if(kind.equals("up")) {%>
			<br />
				<label>기존 파일: <%=pl_fname %></label>
			<%} %>
			</td>
		</tr>
		<tr>
			<th>글 내용</th>
			<td><textarea name="pl_content" rows="10" cols="65" maxlength="500"><%=pl_content %></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
			<input type="submit" class="btn2" value="<%=caption %>" /> 
			<%if(!kind.equals("up")) {%><input type="reset" class="btn2" value="다시 입력" /><%} %> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" class="btn2" value="목록" onclick="location.href='tbAdminPDSList.jsp?cpage=<%=cpage + args%>';" />
			
			</td>
		</tr>
	</table>
	</div>
</form>

<%@ include file="../_inc/inc_foot.jsp"%>