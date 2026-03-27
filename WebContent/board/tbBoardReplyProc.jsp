<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%@ include file="../_inc/incReqList.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int sl_idx = Integer.parseInt(request.getParameter("slidx"));
String schtype = request.getParameter("schtype");
String keyword = request.getParameter("keyword");
String args = "?cpage="+ cpage +"&slidx="+ sl_idx +"&rlidx="+ rl_idx;
if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")){
	args += "&schtype=" + schtype + "&keyword=" + keyword;
	// 링크에 검색 관련 값들을 쿼리스트링으로 연결해줌
}

int sr_idx = 0;
String sr_content = request.getParameter("sr_content");
mi_id = loginInfo.getMi_id();
if (!kind.equals("in")) {	// 댓글 등록이 아닐 경우
	sr_idx = Integer.parseInt(request.getParameter("sr_idx"));
}
try {
	stmt = conn.createStatement();
	
	if (kind.equals("in")) {	// 댓글 등록일 경우
		sql = "update t_"+ rl_tname +"_list set sl_reply = sl_reply + 1 where sl_idx = " + sl_idx;
		stmt.executeUpdate(sql);	// 게시글의 댓글 수 증가 쿼리 실행
		// System.out.println(sql);
		
		sql = "insert into t_"+ rl_tname +"_reply (sl_idx, mi_id, sr_content)" +
		" values (" + sl_idx + ", '" + mi_id + "', '" + sr_content + "')";
		// System.out.println(sql);
	} else if (kind.equals("up")){	// 댓글 수정일 경우
		sql = "update t_"+ rl_tname +"_reply set sr_content = '" + sr_content + "' where mi_id = '" + loginInfo.getMi_id() + "' and sr_idx = " + sr_idx;
		stmt.executeUpdate(sql);
		// System.out.println(sql);
		
	} else if (kind.equals("del")){	// 댓글 삭제일 경우
		sql = "update t_"+ rl_tname +"_list set sl_reply = sl_reply - 1 where sl_idx = " + sl_idx;
		stmt.executeUpdate(sql);
		// System.out.println(sql);
		
		sql = "update t_"+ rl_tname +"_reply set sr_isview = 'n' " + 
		"where mi_id = '" + loginInfo.getMi_id() + "' and sr_idx = " + sr_idx;
		// System.out.println(sql);
		
	} else if (kind.equals("g") || kind.equals("b")) {	// 댓글 좋아요 및 싫어요일 경우
		sql = "update t_"+ rl_tname +"_reply set sr_"+ (kind.equals("g") ? "good" : "bad") +  
		" = sr_" + (kind.equals("g") ? "good" : "bad") + " + 1 where sr_idx = " + sr_idx;
		stmt.executeUpdate(sql);	// 댓글의 좋아요/싫어요 수 증가
		// System.out.println(sql);
	
		sql = "insert into t_"+ rl_tname +"_reply_gnb (mi_id, sr_idx, srg_gnb) values ('" + mi_id + "', " + sr_idx + ", '" + kind + "') ";
		// System.out.println(sql);
		
	} else {
		out.println("<script>");
		out.println("history.back();");
		out.println("</script>");
	}
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1){
		out.println("location.replace('tbBoardView.jsp" + args + "');");
	} else {
		out.println("alert('댓글 등록에 실패했습니다.\\n다시 시도하세요.');");
		out.println("history.back();");
	}
		out.println("</script>");

} catch (Exception e){
	out.println("댓글 관련 문제가 발생하였습니다.");
	e.printStackTrace();
} finally {
	try {stmt.close();}
	catch (Exception e) {e.printStackTrace();}
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>