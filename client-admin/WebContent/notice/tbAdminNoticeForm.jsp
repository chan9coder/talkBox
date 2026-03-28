<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%

request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
String caption = "등록"; // 버튼에 사용할 캡션 문자열
String action = "tbAdminNotice_proc.jsp";
String nl_ctgr = "", nl_title = "", nl_content = "", nl_isview = "n";
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
	action = "tbAdminNotice_proc.jsp";
	try{
		stmt = conn.createStatement();
		sql = "select * from t_notice_list where nl_isview = 'y' and nl_idx=" + idx;
		rs = stmt.executeQuery(sql);
		if(rs.next()){
			nl_content=rs.getString("nl_content");
			nl_ctgr=rs.getString("nl_ctgr");
			nl_title=rs.getString("nl_title");		
			nl_isview=rs.getString("nl_isview");
		} else {
			out.print("<script>");
			out.print("alert('존재하지 않는 게시물입니다.');");
			out.print("history.back();");
			out.print("</script>");
			out.close();	
		}
		
	}catch(Exception e){
		out.println("공지사항 글수정폼에서 문제가 발생했습니다.");
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
<style>
#formBtn {
    display: inline-block;
    position: absolute;
    left: 600px;
    top: 470px;
}
</style>

<form name="frm" action="<%=action %>" method="post">
	<input type="hidden" name="kind" value="<%=kind %>" />
	<input type="hidden" name="ai_idx" value="<%=ai_idx%>" />
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
<div id="listP">
	<h2>공지사항 글<%=caption %></h2><br />
	<table width="1000" cellpadding="5">
		<tr>
			<th width="15%">글제목</th>
			<td width="*"><select name="nl_ctgr">
					<option <% if (nl_ctgr.equals("공지")) { %> selected="selected"
						<%} %>>공지</option>
					<option <% if (nl_ctgr.equals("이벤트")) { %> selected="selected"
						<%} %>>이벤트</option>
					<option <% if (nl_ctgr.equals("보도자료")) {%> selected="selected"
						<%} %>>보도자료</option>
			</select> <input type="text" name="nl_title" size="49" maxlength="100" value='<%=nl_title %>' />

			</td>
		</tr>
		<tr>
			<th>글 내용</th>
			<td><textarea name="nl_content" rows="10" cols="65" maxlength="500" valign="top"><%=nl_content %></textarea>
		</tr>
	</table>
</div>
<div id="formBtn">
<table width="1000" cellpadding="5">
	<tr>
			<td colspan="2"  align="center"><input type="submit" class="btn2" value="<%=caption %>" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			<%if(!kind.equals("up")) {%><input type="reset" class="btn2" value="다시 입력" /><%} %> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			<input type="button" class="btn2" value="목록" onclick="location.href='tbAdminNoticeList.jsp?cpage=<%=cpage + args%>';" />
			</td>
		</tr>
</table>
</div>
</form>


<%@ include file="../_inc/inc_foot.jsp"%>