<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
int cpage = 1, psize = 10, bsize =10, rcnt =0, pcnt =0;
//페이지 번호, 페이지 크기, 블록 크기, 레코드(게시글) 개수, 페이지 개수 등을 저장할 변수

if (request.getParameter("cpage") != null)
	cpage = Integer.parseInt(request.getParameter("cpage"));

String schtype = request.getParameter("schtype");
String keyword = request.getParameter("keyword");
String schargs = "";
String where = " where fl_isview = 'y' ";

if(schtype == null || schtype.equals("") || keyword == null || keyword.equals("")){	//검색을 하지 않는 경우
	schtype =""; 	keyword = "";
} else {
	keyword = getRequest(keyword);
	URLEncoder.encode(keyword,"UTF-8");
	//쿼리스트링으로 주고 받는 검색어가 한글일 경우 IE에서 문제가 발생할 수 있으므로 유니코드로 변환
	
	if (schtype.equals("tc")){	//검색조건이 '제목+내용'일 경우
		where += "and (fl_title like'%"+ keyword + "%' "+ "or fl_content like '% "+ keyword + "%') ";
	}else if(schtype.equals("writer")){ //검색조건이 '작성자'일 경우
		where += " and fl_writer ='"+ keyword + "' ";		
	} else{	//검색조건이 '제목'이거나 '내용'일 경우
		where += " and fl_" + schtype + " like '%"+ keyword + "%' ";
	}
	schargs = "&schtype="+ schtype + "&keyword=" + keyword;
//	System.out.print(schargs);
	// 검색조건이 있을 경우 링크의 url에 붙일 쿼리스트링 완성
}
try{
	stmt = conn.createStatement();
	
	sql = "select count(*) from t_free_list "+ where;
	//자유게시판 레코드의 개수(검색조건 포함)을 받아 올 쿼리
	rs =  stmt.executeQuery(sql);
	if(rs.next()) rcnt = rs.getInt(1);
	
	pcnt = rcnt / psize;
	if (rcnt % psize > 0)	pcnt++;
	
	int start = (cpage - 1)*psize;
	sql = "select fl_idx, fl_ismem, fl_writer, fl_title, fl_reply, fl_read, "+
		  "if (curdate() = date(fl_date), time(fl_date) ,replace(mid(fl_date, 3,8), '-', '.')) fldate "+
		  "from t_free_list "+ where +" order by fl_idx desc limit "+ start + ", " + psize;
	rs = stmt.executeQuery(sql);
	
}catch(Exception e){
	out.print("자유게시판 목록에서 문제가 발생했습니다.");
	e.printStackTrace();
}
%>
<h2>자유 게시판 목록</h2>
<div style="width: 700px; text-align: right;">
	<form name="frmSch">
		<fieldset>
			<select name="schtype">
				<option value="title" <%if(schtype.equals("title")) {%>
					selected="selected" <%} %>>제목</option>
				<option value="content" <%if(schtype.equals("content")) {%>
					selected="selected" <%} %>>내용</option>
				<option value="writer" <%if(schtype.equals("writer")) {%>
					selected="selected" <%} %>>작성자</option>
				<option value="tc" <%if(schtype.equals("tc")) {%>
					selected="selected" <%} %>>제목+내용</option>
			</select> <input type="text" name="keyword" value="<%=keyword %>" /> <input
				type="submit" value="검색" />&nbsp;&nbsp;&nbsp;&nbsp; <input
				type="button" value="전체 글보기" onclick="location.href='free_list.jsp'" />
		</fieldset>
	</form>
</div>
<table width="700" border="0" cellpadding="0" cellspacing="0" id="list">
	<tr height="30">
		<th width="10%">번호</th>
		<th width="*">제목</th>
		<th width="15%">작성자</th>
		<th width="15%">작성일</th>
		<th width="10%">조회</th>
	</tr>
	<%
if (rs.next()){
	int num = rcnt -(cpage -1 ) * psize;
	do{
		int titleCnt =24;
		String reply ="", title = rs.getString("fl_title");
		if(rs.getInt("fl_reply")>0){
			titleCnt = titleCnt -3;
			reply = " ["+ rs.getInt("fl_reply") +"]";
		} 
		
		if(title.length() > 23){
			title = title.substring(0,titleCnt -3)+ "...";
		}
		title = "<a href = 'free_view.jsp?idx=" + rs.getInt("fl_idx") + 
				"&cpage="+ cpage + schargs+"'>"+ title +"</a>"+reply;
		//System.out.print(title);
		String writer = rs.getString("fl_writer");
		if(rs.getString("fl_ismem").equals("y")){	//회원글일 경우
			writer = writer.substring(0,5) +"***";
		}
%>
	<tr height="30" align="center">
		<td><%=num %></td>
		<td align="left"><%=title %></td>
		<td><%=writer %></td>
		<td><%=rs.getString("fldate") %></td>
		<td><%=rs.getString("fl_read") %></td>
	</tr>
	<%
	num--;
	} while(rs.next());
} else {	//보여줄 게시글이 없을 경우
	out.print("<tr height='30'><td coldpan='5' align='center'>");
	out.print("검색결과가 없습니다.<td></tr>");
}

%>
</table>
<br />
<table width="700">
	<tr>
		<td width="600">
			<%
if (rcnt > 0) {	//게시글이 있으면
	String link = "free_list.jsp?cpage=";
	if(cpage == 1){
		 out.print("[처음]&nbsp;&nbsp;&nbsp;[이전]&nbsp;&nbsp;");
	} else {
		 out.print("<a href='"+ link + "1" + schargs + "'>[처음]</a>&nbsp;&nbsp;&nbsp;");		 
		 out.print("<a href='"+ link + (cpage - 1) + schargs + "'>[이전]</a>&nbsp;&nbsp;");		 
	}
	int spage = (cpage - 1) / bsize * bsize +1;		//블록 시작페이지 번호
	for (int i =1, j= spage; i<=bsize && j <=pcnt; i++,j++){
	// i : 블록에서 보여줄 페이지의 개수만큼 루프를 돌릴 조건으로 사용되는 변수
	// j : 실제 출력할 페이지 번호로 전체 페이지 개수(마지막 페이지 번호)를 넘지 않게 할 변수 
		if(j == cpage){
	 		out.print("&nbsp;<strong>" + j + "</strong>&nbsp;");
	 	} else {
	 		out.print("&nbsp;<a href='"+ link + j + schargs + "'>"+j+"</a>&nbsp;");
	 	}
	}
	if (cpage == pcnt){
		 out.print("&nbsp;&nbsp;[다음]&nbsp;&nbsp;&nbsp;[마지막]");
	} else {
	 	out.print("&nbsp;&nbsp;");		 
	 	out.print("<a href='"+ link + (cpage + 1) + schargs + "'>[다음]</a>");
	 	out.print("&nbsp;&nbsp;&nbsp;");	
	 	out.print("<a href='"+ link + pcnt + schargs + "'>[마지막]</a>");		 
	}
}
%>
		</td>
		<td width="*" align="right"><input type="button" value="글등록"
			onclick="location.href='free_form.jsp?kind=in';" /></td>
	</tr>
</table>
<%@ include file="../_inc/inc_foot.jsp"%>