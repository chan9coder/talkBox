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
}
//view 화면에서 보여줄 게시들의 정보들을 저장할 변수들
String fl_ismem = "", fl_writer = "", fl_title = "", fl_content = "", fl_date = "";
int fl_read = 0, fl_reply = 0;

try{
	stmt =conn.createStatement();
	sql = "update t_free_list set fl_read = fl_read + 1 where fl_idx ="+idx;
	stmt.executeUpdate(sql);	//조회수 증가 쿼리 실행
	
	sql = "select * from t_free_list where fl_isview ='y' and fl_idx="+idx;
	rs = stmt.executeQuery(sql);
	
	
	if(rs.next()){
		fl_ismem =rs.getString("fl_ismem");		fl_writer =rs.getString("fl_writer");
		fl_title =rs.getString("fl_title");		fl_date =rs.getString("fl_date");
		fl_read =rs.getInt("fl_read");
		fl_content =rs.getString("fl_content").replace("\r\n"," <br >");
		fl_reply = rs.getInt("fl_reply");
		
	} else {
		out.print("<script>");
		out.print("alert('존재하지 않는 게시물입니다.');");
		out.print("history.back();");
		out.print("</script>");
		out.close();
		
	}
}catch(Exception e){
	out.println("게시글 보기시 문제가 발생했습니다.");
	e.printStackTrace();
}

%>
<div id="listP">
<table width="700" >
<td align="left"><h2>자유게시판 글</h2></td>
</table>
<table width="700" cellpadding="5" cellpadding="5" id="viewSty" border="1">
	<tr>
		<th width="12%">작성자</th>
		<td width="13%"><%=fl_writer %></td>
		<th width="12%">작성일</th>
		<td width="20%"><%=fl_date %></td>
		<th width="12%">조회수</th>
		<td width="5%"><%=fl_read %></td>
	</tr>

	<tr>
		<th>제목</th>
		<td colspan="5"><%=fl_title %></td>
	</tr>
	<tr>
		<td colspan="6" style="height:500px" valign="top"><%=fl_content %></td>
	</tr>
	 <%
boolean isPms = false;	//수정과 삭제 버튼을 현 사용자에게 보여줄지 여부를 저장할 변수
String upLink = "", delLink ="";	//수정과 삭제용 링크를 저장할 변수
if(fl_reply == 0){	//댓글이 없을 경우에만 수정과 삭제를 허용
	if(fl_ismem.equals("n")){	//현재 글이 비회원 글일 경우
		isPms = true;
		upLink ="free_form_pw.jsp"+args + "&kind=up&idx="+idx;
		delLink ="free_form_pw.jsp"+args + "&kind=del&idx="+idx;
	}
}

%> 

</table>
<table width="700" cellpadding="5" >
<td colspan="6" align="right">
<input type="button" class="btn2" value="목록" onclick="location.href='tbAdminfreeList.jsp<%=args %>';" /></td>
</table>
<hr width="700" align="left" />
<%
String msg ="placeholder ='로그인 후에 사용할 수 있습니다.'";
String dis = "disabled='disabled'";
String login = "onclick='goLogin(\"댓글 등록\"); '";
if(isLogin){
	msg="";	dis=""; login="";
}

%>
<style>
.txt{ width:530px;height:60px;}
.btn{ width:120px;height:60px;}
.frmUp { display:none; }
</style>
<script>
function goLogin(msg){
	if(confirm(msg + " 로그인이 필요합니다. \n로그인 화면으로 이동하시겠습니까?")){
		location.href = "../login_form.jsp?url=<%=loginUrl %>";
	}
}

function setCharCount(con, fr_idx){
	var cnt = con.value.length;
	var obj = document.getElementById("charCnt" + fr_idx);
	obj.innerHTML = cnt;
	if(cnt > 200){
		alert("댓글은 200자 까지만 입력가능합니다.");
		con.value = con.value.substring(0,200);
		obj.innerHTML = 200;
	}
	
}
function replyDel(fr_idx){
	if(confirm("정말 삭제하시겠습니까?")){
		location.href="free_reply_proc.jsp<%=args %>&kind=del&fl_idx=<%=idx %>&fr_idx=" + fr_idx;
		
	}
}
function replyUp(fr_idx){
// 'u'버튼을 클릭한 위치의 폼을 보여주거나 숨기는 함수
	var frm = document.getElementById("frm"+fr_idx);
	console.log(frm);
	if(frm.style.display == "block") 	frm.style.display = "none";
	else								frm.style.display = "block";
}
function goGnB(gnb,fr_idx){
	//로그인한 회원이 '좋아요' 또는 '싫어요'를 클릭할 경우 이동시키는 함수
		var frm = document.frmGnB;
		frm.kind.value =gnb;
		frm.fr_idx.value =fr_idx;
		frm.submit();	
	}
</script>
<!-- 댓글 목록 영역 시작 -->
<div id="replyBox" style="width:700px; text-align:center;">
	<hr />
	<table width="100%" cellpadding="0" cellspacing="0" border="0" id="list">
	<tr><td colspan="5" align="left">댓글개수 : <%=fl_reply %>개</td></tr>
<%
sql="select*from t_free_reply where fr_isview='y' and fl_idx= "+idx;
try{
	rs = stmt.executeQuery(sql);
	if(rs.next()){	// 해당 게시글에 댓글이 있을 경우
		do{
			String date = rs.getString("fr_date").substring(2,10) + "<br />"+
						  rs.getString("fr_date").substring(11);
			
			String gLink = "goLogin('좋아요는');", bLink = "goLogin('싫어요는');";
			
%>	
<tr align="left" valign="top">
	<td width="70" ><%=rs.getString("mi_id").substring(0,5) %>***</td>
	<td width="*"><%=rs.getString("fr_content").replace("\r\n","<br />") %></td>
	<td width="70"><%=date %></td>
	<td width="70" align="right">
		<img src="../img/g.png" width="20" title="좋아요" class="hand" onclick="<%=gLink %>" /><%=rs.getInt("fr_good")  %><br />
		<img src="../img/b.png" width="20" title="싫어요" class="hand" onclick="<%=bLink %>" /><%=rs.getInt("fr_bad")  %>
	</td>
</tr>
<tr><td colspan="5">
<%
		}while(rs.next());
	}else{			// 해당 게시글에 댓글이 없을 경우
		out.println("<tr><td align='center'>댓글이 없습니다.</td></tr>");
	}
	
}catch(Exception e){
	out.print("댓글 목록에서 문제가 생겼습니다.");
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
	</table>
</div>
<form name="frmGnB" action="free_reply_proc.jsp<%=args %>" method="post">
<input type="hidden" name="kind" value="" />
<input type="hidden" name="fl_idx" value="<%=idx %>" />
<input type="hidden" name="fr_idx" value="" />
</form>
</div>
<%@ include file="../_inc/inc_foot.jsp"%>