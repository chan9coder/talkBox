<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%@ include file="../_inc/incReqList.jsp" %>
<%
request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int sl_idx = Integer.parseInt(request.getParameter("slidx"));
String schtype = request.getParameter("schtype");	// 검색조건
String keyword = request.getParameter("keyword");	// 검색어
String args = "?cpage=" + cpage +"&slidx="+ sl_idx +"&rlidx="+ rl_idx;
if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")){
	args += "&schtype=" + schtype + "&keyword=" + keyword;
	// 링크에 검색 관련 값들을 쿼리스트링으로 연결해줌
}

// view 화면에서 보여줄 게시글의 정보들을 저장할 변수들
String sl_ismem = "", sl_writer= "", sl_title= "", sl_content= "", sl_date = "";
int sl_read = 0, sl_reply = 0;

try {
	stmt = conn.createStatement();
	sql = "update t_"+ rl_tname +"_list set sl_read = sl_read + 1 where sl_idx = " + sl_idx;
	stmt.executeUpdate(sql);	// 조회수 증가 쿼리 실행
	// System.out.println(sql);
	
	sql = "select * from t_"+ rl_tname +"_list where sl_isview = 'y' and sl_idx = " + sl_idx;
	rs = stmt.executeQuery(sql);
	// System.out.println(sql);
	if (rs.next()){
		sl_idx = rs.getInt("sl_idx");
		sl_ismem = rs.getString("sl_ismem");
		sl_writer = rs.getString("sl_writer");
		sl_title = rs.getString("sl_title");
		sl_date = rs.getString("sl_date");
		sl_read = rs.getInt("sl_read");
		sl_content = rs.getString("sl_content").replace("\r\n", "<br />");
		sl_reply = rs.getInt("sl_reply");
		
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
if(sl_ismem.equals("y")) {
	sl_writer = sl_writer.substring(0,5) + "***";
}
%>
<h2 align="center" style="color:green" ><%=rl_name %>게시판 글 보기</h2>
<table width="700" cellpadding="5" align="center">
<tr>
<th width="10%">작성자</th>
<td width="13%"><%=sl_writer %></td>

<th width="10%">작성일</th><td width="*%"><%=sl_date %></td>
<th width="10%">조회수</th><td width="13%"><%=sl_read %></td>
</tr>
<tr><th>제목</th><td colspan="5"><%=sl_title %></td></tr>
<tr><th>내용</th><td colspan="5"><%=sl_content %></td></tr>
<tr><td colspan="6" align="center"><hr />
<%
boolean isPms = false;	// 수정과 삭제 버튼을 현 사용자에게 보여줄지 여부를 저장할 변수
String upLink = "", delLink = "";
if (sl_reply == 0){	// 댓글이 없을 경우에만 수정과 삭제를 허용
	if (sl_ismem.equals("n")){	// 현재글이 비회원 글일 경우
		isPms = true;
		upLink = "tbBoardFormPw.jsp"+ args +"&kind=up&slismem="+ sl_ismem +"&schtype="+ schtype;
		delLink = "tbBoardFormPw.jsp"+ args +"&kind=del&slismem="+ sl_ismem +"&schtype="+ schtype;
	} else {	// 현재글이 회원글일 경우
		if (isLogin && loginInfo.getMi_id().equals(rs.getString("sl_writer"))){
		// 현재 로그인이 되어 있는 상태에서 현 로그인 사용자가 현 게시글을 입력한 회원일 경우
			isPms = true;
			upLink = "tbBoardForm.jsp"+ args +"&kind=up&slismem="+ sl_ismem +"&schtype="+ schtype;
			delLink = "tbBoardProcDel.jsp"+ args +"&rltname="+rl_tname;
		}
	}
}

if (isPms) {
%>	
	<input type="button" value="글수정" onclick="location.href='<%=upLink %>';" class="clickbtn"/>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<script>
function isDel() {
	if (confirm("정말 삭제하시겠습니까?\n삭제된 글은 되살릴 수 없습니다.")){
		location.href="<%=delLink%>";
	}
}
</script>
	<input type="button" value="글삭제" onclick="isDel();" />
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<% }%>
	<input type="button" value="글목록" onclick="location.href='tbBoardList.jsp<%=args %>';" class="clickbtn"/>
</td></tr>
</table>
<%
String msg = " placeholder='로그인 후에 사용하실 수 있습니다.'";
String dis = " disabled='disabled'";
String login = "onclick='goLogin(\"댓글등록\");'";
if (isLogin){
	msg = ""; dis = "";	login= "";
}

%>
<style>
.txt { width:530px; height:60px;}
.btn {width:100px; height:60px; background-color:#00b050; color:white;}
.frmUp {display:none;}
.clickbtn {background-color:#92d050; color:white;}
</style>
<script>
function goLogin(msg) {
	if (confirm(msg + " 로그인이 필요합니다.\n로그인 화면으로 이동하시겠습니까?")){
		location.href="../tbLoginForm.jsp?url=<%=loginUrl%>";
	}
}

function setCharCount(con, sr_idx){
	var cnt = con.value.length;
	var obj = document.getElementById("charCnt" + sr_idx);
	obj.innerHTML = cnt;
	
	if (cnt > 200) {
		alert("댓글은 200자 까지만 입력가능합니다.")
		con.value = con.value.substring(0, 200);
		obj.innerHTML = 200;
	}
}

function replyDel(sr_idx){
	if (confirm("정말 삭제하시겠습니까?")){
		location.href="tbBoardReplyProc.jsp<%=args %>&kind=del&slidx=<%=sl_idx%>&sr_idx=" + sr_idx;
	}
}
function replyUp(sr_idx){
// 'u'버튼을 클릭한 위치의 폼을 보여주거나 숨기는 함수
	var frm = document.getElementById("frm" + sr_idx);
	if (frm.style.display == "block"){
		frm.style.display = "none";
	} else {
		frm.style.display = "block";
	}
}
function goGnB(gnb, sr_idx){
// 로그인한 회원이 '좋아요' 또는 '싫어요'를 클릭할 경우 이동시키는 함수
	var frm = document.frmGnB;
	frm.kind.value = gnb;
	frm.sr_idx.value = sr_idx;
	frm.submit();
}
</script>
<hr width="700" align="center" />
<!-- 댓글 목록 영역 시작 -->
<div id="replyBox" style="width:700px; text-align:center; margin: 0 auto;">
	<form name="frmReply" action="tbBoardReplyProc.jsp<%=args %>" method="post">
	<input type="hidden" name="kind" value="in" />
	<input type="hidden" name="sl_idx" value="<%=sl_idx %>" />
	<table width="100%" cellpadding="5">
	<tr>
	<td width="550" align="right">
	<textarea name="sr_content" class="txt" <%=msg + login%> onkeyup="setCharCount(this, '');"></textarea>
	<br />200자 이내로 입력하세요. (<span id="charCnt">0</span> / 200)
	</td>
	<td width="*" valign="top">
	<input type="submit" value="댓글 등록" class="btn" <%=dis %>/>
	</td>
	</table>
	</form>
	<hr />
	<table width="100%" cellpadding="0" cellspacing="0" border="0" id="list">
	<tr><td colspan="5" align="left">댓글 개수 : <%=sl_reply %>개</td></tr>
<%
sql = "select * from t_"+ rl_tname +"_reply where sr_isview = 'y' and sl_idx =" + sl_idx;
// System.out.println(sql);
try {
	rs = stmt.executeQuery(sql);
	if (rs.next()){	// 해당 게시글에 댓글이 있을 경우
		do {
			String date = rs.getString("sr_date").substring(2, 10) +"<br />" + rs.getString("sr_date").substring(11);
			
			String gLink = "goLogin('좋아요는');", bLink = "goLogin('싫어요는');";
			if (isLogin) {
				sql = "select 1 from t_"+ rl_tname +"_reply_gnb where mi_id = '" + 
				loginInfo.getMi_id() +"' and sr_idx = " + rs.getInt("sr_idx");
				System.out.println(sql);
				Statement stmt2 = conn.createStatement();
				ResultSet rs2 = stmt2.executeQuery(sql);
				if (rs2.next()){	// 이미 현 댓글에 대해 좋아요 또는 싫어요를 했을 경우
					gLink = "alert('이미 참여했습니다.');"; bLink = gLink;
				} else {	// 아직 좋아요 또는 싫어요를 안했을 경우
					gLink = "goGnB('g', " + rs.getInt("sr_idx") + ");";
					bLink = "goGnB('b', " + rs.getInt("sr_idx") + ");";
				}
				try {rs2.close(); stmt2.close();}
				catch(Exception e){e.printStackTrace();}
			}
%>
	<tr align="left" valign="top">
	<td width="70"><%=rs.getString("mi_id").substring(0, 5)%>***</td>
	<td width="*"><%=rs.getString("sr_content").replace("\r\n", "<br />")%></td>
	<td width="70"><%=date %></td>
	<td width="70" align="right">
		<img src="../img/g.png" width="20" title="좋아요" class="hand" onclick="<%=gLink %>"/><%=rs.getInt("sr_good") %><br />
		<img src="../img/b.png" width="20" title="싫어요" class="hand" onclick="<%=bLink %>"/><%=rs.getInt("sr_bad") %>
	</td>
	<td width="22" align="right">
<% 		if (isLogin && loginInfo.getMi_id().equals(rs.getString("mi_id"))) {%>
	<img src="../img/delete.png" width="20" title="댓글삭제" class="hand" 
		onclick="replyDel(<%=rs.getInt("sr_idx")%>);"/><br />
	<img src="../img/modify.png" width="20" title="댓글수정" class="hand" 
		onclick="replyUp(<%=rs.getInt("sr_idx") %>);" />
<%} %>
</td>
</tr>
<tr><td colspan="5">
<% if (isLogin && loginInfo.getMi_id().equals(rs.getString("mi_id"))) {%>
	<form name="frmReply" action="tbBoardReplyProc.jsp<%=args %>" method="post" class="frmUp" id="frm<%=rs.getInt("sr_idx") %>">
	<input type="hidden" name="kind" value="up" />
	<input type="hidden" name="sl_idx" value="<%=sl_idx %>" />
	<input type="hidden" name="sr_idx" value="<%=rs.getInt("sr_idx") %>" />
	<table width="100%" cellpadding="5">
	<tr>
		<td width="550" align="right">
		<textarea name="sr_content" class="txt" onkeyup="setCharCount(this, '<%=rs.getInt("sr_idx") %>');"><%=rs.getString("sr_content") %></textarea>
		<br />200자 이내로 입력하세요. (<span id="charCnt<%=rs.getInt("sr_idx")%>"><%=rs.getString("sr_content").length() %></span> / 200)
	</td>
	<td width="*" valign="top">
		<input type="submit" value="댓글 수정" class="btn" />
	</td>
	</tr>
	</table>
	</form>
<%} %>
</td></tr>
<%
		} while(rs.next());
	}else{	// 해당 게시글에 댓글이 없을 경우
		out.println("<tr><td align='center'>댓글이 없습니다.</td></tr>");
	}
	
} catch (Exception e){
	out.println("댓글 목록에서 문제가 생겼습니다.");
	e.printStackTrace();
}finally {
	try { rs.close();	stmt.close();} 
	catch (Exception e) { e.printStackTrace(); }
}
%>	
	</table>
</div>
	<form name="frmGnB" action="tbBoardReplyProc.jsp<%=args%>" method="post">
		<input type="hidden" name="kind" value="" />
		<input type="hidden" name="sl_idx" value="<%=sl_idx%>" />
		<input type="hidden" name="sr_idx" value="" />
	</form>
<%@ include file="../_inc/inc_foot.jsp" %>

